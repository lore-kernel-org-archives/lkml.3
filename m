Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab3CUUdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:33:46 -0400
Received: from mail-db8lp0185.outbound.messaging.microsoft.com ([213.199.154.185]:3500
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612Ab3CUUdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:33:43 -0400
X-Forefront-Antispam-Report: CIP:160.33.194.231;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail04v.am.sony.com;RD:mail04.sonyusa.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zzbb2dI98dI936eI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzzz2fh2a8h668h839h947hd25hf0ah10d2h1288h12a5h12a9h12bdh137ah13b6h1441h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1b0ah1724k1155h)
Message-ID: <514B6E5F.2040405@am.sony.com>
Date: Thu, 21 Mar 2013 13:32:31 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
CC: Ming Lei <tom.leiming@gmail.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "steve.glendinning@smsc.com" <steve.glendinning@smsc.com>
Subject: Re: [BUG] bisected: PandaBoard smsc95xx ethernet driver error from
 USB timeout
References: <514A7E81.9000501@am.sony.com> <CACVXFVODZNuoLYSk60YwhFhEv5SX2QkszjjoYDWBHij7zwmhdQ@mail.gmail.com> <514B6CAF.3090406@am.sony.com>
In-Reply-To: <514B6CAF.3090406@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/13 13:25, Frank Rowand wrote:
> On 03/21/13 02:00, Ming Lei wrote:

< snip >

> ----------
> There are some timeout messages that I am not positive are symptoms of
> the problem.  With these messages, the smsc95xx driver initialization is
> successful, so the ethernet device is available.  For the first bisect
> attempt, I did not treat these messages as errors.  For the second bisect
> attempt I treated these messages as errors.  A typical example of the
> timeout message is:
> 
>   [    9.537811] hub 1-1:1.0: state 7 ports 5 chg 0000 evt 0002
>   [   17.056701] usb 1-1.1: swapper/0 timed out on ep0out len=0/4
>   [   17.062652] smsc95xx 1-1.1:1.0: eth0: Failed to write register index 0x00000108
>   [   17.070343] smsc95xx 1-1.1:1.0: eth0: Failed to write ADDRL: -110
>   [   17.076751] IP-Config: Failed to open eth0

Oops, pasted the wrong example.  This is an example of a timeout, but the
driver still works, and the system boots:

  [    6.072357] smsc95xx 1-1.1:1.0: eth0: register 'smsc95xx' at usb-ehci-omap.0-1.1, smsc95xx USB 2.0 Ethernet, fa:50:73:02:79:67
  [    6.084655] hub 1-1:1.0: state 7 ports 5 chg 0000 evt 0002
  [   11.220672] usb 1-1.1: swapper/0 timed out on ep0out len=4/4
  [   18.183441] usb 1-1.1: link qh8-0001/dc8d6640 start 2 [1/0 us]
  [   19.822296] IP-Config: Complete:

> 
>   The mention of swapper is not relevent, it just happens to be the
>   current process when the time out occurs.
> 
> I have only seen these timeout messages in the boot log, so they may not
> be a very visible symptom.  They also _might_ be unrelated to the problem,
> but my gut feel is that they are related.

< snip >

-Frank

