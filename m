Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbbAEKHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:07:06 -0500
Received: from sf1.bxl.stone.is ([87.238.167.36]:54583 "EHLO sf1.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbbAEKHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:07:01 -0500
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <54AA6231.5040101@acm.org>
Date: Mon, 05 Jan 2015 11:06:41 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sabrina Dubroca <sd@queasysnail.net>,
        Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com
Subject: Re: e1000_netpoll(): disable_irq() triggers might_sleep() on linux-next
References: <20141029155620.GA4886@kria> <20141029180734.GQ12706@worktop.programming.kicks-ass.net> <alpine.DEB.2.11.1410291918060.5308@nanos> <20141029193603.GS12706@worktop.programming.kicks-ass.net> <20141202163530.GA19420@kria>
In-Reply-To: <20141202163530.GA19420@kria>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Filter-ID: s0sct1PQhAABKnZB5plbIYrcAt68paBzxGNV4bZScc8DDDH9IcRzs4ldqK5vEMwbuZt+PpRPW1h0
 yigPev+a+xPfldKzuJPXOtlQy6CerCucKeF7cnfEDaU4uWev4XxITtMxQ0r0fzIlxS2cy8YTUsFr
 pZdaq+BCu90GH4R8NZlq5nVSHx6HfgQ+mNfWMu0Xb4BcbCUUDkSDryyTxLFNrKWkIvD5dv0Ys3LQ
 YBKCmf23wL2Y4F0412ezGCyTUPanjX4dmbjHuB9XXavPbeVA0qbDNqfbnqFv/RRVV8+drYe2Z/+T
 EGTrNArD+yzRk5+QRS1SBS4NdDPZvgM0xf/+ywhW0lr5GKYox2HMYMWL/Gq6/LC8fIr+o2PTyzwb
 IRBgoJmRXV1dP/tOC4B0z0hUqa+Ln89F976wnGIs0GswJSnlgTl6fJxyntEfhZCKje4ZowN3TuKb
 dxely6NczQbrfOHXgQ9YVFCeKdQbUxRelTE37CgHhlCYKFAFYSG0HH07RdUb66pqYAGPsHnfde2g
 sQIUFW3nE6W+p6XUHoN9n2IRxcJV+m8q0YzC/hf5MMnnXIz52/8cMid9thISoDAJMOfnPadBpPx3
 4iZ7zgupsYUufA8kn04GPwlkALZGivcxme4bPsB8V7MXmgIm96hFx4TQGMbESva0q3Q4fBLCHBUD
 wx4T7HCAozCuhJa/y4Npp3lkYb5oHl6M0x3YCZ4kJXtwiFqyNzRdU+uiDe6Y+N0suVaOsTohfZcZ
 Am3ZkGbkwuDV395FgBjCTs45+hnH8geYUOp7A73HI6oJg7w/VodVrEuplbOdig7nFAukRgZ9cixD
 z6TLWXvYHXEhLaJtyQ==
X-Report-Abuse-To: spam@sf1.bxl.stone.is
X-Filter-Fingerprint: IFrWXGses7OKB5S5G8/dJR8Z5VD7FZiiT9tK6RAzQuhA3cTUQ1R++keuE7RDJ8Kg3RbMLUalw1oC
 mj99/u+PoqoVy8a3lsStJtAvpObFX0Wok1JBYnOLzfRIhlEHQynLUpndEJ0YoaLytXXo8BMTaX2p
 Mk7LBarWD9Fj4R3eIu5cOy/3Wm9qfF/CZNvP/2Kowv61T+KDYyYtREgszdyFwv8IxCB3p/oCKvxr
 eyISh3JGb7OS5oVgiO+kDxZrVPLz3MmEGC2PrUKqLq5WmHK+Nw==
X-Originating-IP: 87.238.167.34
X-SpamExperts-Domain: stone.is
X-SpamExperts-Username: 87.238.167.34
Authentication-Results: bxl.stone.is; auth=pass smtp.auth=87.238.167.34
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: Combined (0.04)
X-Recommended-Action: accept
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/14 17:35, Sabrina Dubroca wrote:
> @@ -3751,10 +3753,8 @@ void e1000_update_stats(struct e1000_adapter *adapter)
>   * @irq: interrupt number
>   * @data: pointer to a network interface device structure
>   **/
> -static irqreturn_t e1000_intr(int irq, void *data)
> +static irqreturn_t __e1000_intr(int irq, struct e1000_adapter *adapter)
>  {
> -	struct net_device *netdev = data;
> -	struct e1000_adapter *adapter = netdev_priv(netdev);
>  	struct e1000_hw *hw = &adapter->hw;
>  	u32 icr = er32(ICR);
>  
> @@ -3796,6 +3796,19 @@ static irqreturn_t e1000_intr(int irq, void *data)
>  	return IRQ_HANDLED;
>  }
>  
> +static irqreturn_t e1000_intr(int irq, void *data)
> +{
> +	struct net_device *netdev = data;
> +	struct e1000_adapter *adapter = netdev_priv(netdev);
> +	irqreturn_t ret;
> +
> +	netpoll_irq_lock(&adapter->netpoll_lock);
> +	ret = __e1000_intr(irq, adapter);
> +	netpoll_irq_unlock(&adapter->netpoll_lock);
> +
> +	return ret;
> +}
> +
>  /**
>   * e1000_clean - NAPI Rx polling callback
>   * @adapter: board private structure
> @@ -5220,9 +5233,7 @@ static void e1000_netpoll(struct net_device *netdev)
>  {
>  	struct e1000_adapter *adapter = netdev_priv(netdev);
>  
> -	disable_irq(adapter->pdev->irq);
>  	e1000_intr(adapter->pdev->irq, netdev);
> -	enable_irq(adapter->pdev->irq);
>  }
>  #endif

Sorry but this patch looks incorrect to me. Since e1000_netpoll() can be
called with interrupts disabled e1000_intr() must not enable interrupts
unconditionally. Shouldn't the save / restore variants be used in
e1000_intr() instead of spin_lock_irq() and spin_unlock_irq() ? See also
the invocation of call_console_drivers() in console_unlock().

Bart.
