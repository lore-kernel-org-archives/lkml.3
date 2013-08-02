Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab3HBCsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:48:41 -0400
Received: from plane.gmane.org ([80.91.229.3]:44616 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754176Ab3HBCsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:48:39 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: PROBLEM: 3.11.0-rc2+ lost of connectivity
Date: Fri, 2 Aug 2013 02:47:50 +0000 (UTC)
Message-ID: <ktf6km$rsu$1@ger.gmane.org>
References: <CAOSRKdTOcYOZ4fD5gXe_57dA028rGmR30T32FQ6MeruAq2p04g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 60.160.69.36
User-Agent: slrn/0.9.9p1 (Linux)
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Aug 2013 at 14:34 GMT, Sebastiano Spicuglia <spicuglia.sebastiano@gmail.com> wrote:
>
> The machine suddenly stops to be connected to the network.
> Running "ifdown eth0" "ifup eth0" the network starts to work
> again for few minutes and then the failure happens again.
> It is not even possible to ping the machine.
> /var/log/messages does not report anything wrong.
>
> I instrumented the kernel with SystemTap to see what happens when the
> machine is in the failure state.
>
> the function ip_rcv is invoked.
> the function ip_rcv_finish is invoked.
> the function ip_local_deliver is invoked
> the function ip_local_deliver_finish is invoked
> the function tcp_v4_rcv is NOT invoked
>
> When the network works the function tcp_v4_rcv is invoked.
>

Please turn off your firewall and run dropwatch to see where the
packets are dropped.

