Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbaG1EpC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 00:45:02 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:50642 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaG1Eo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 00:44:59 -0400
Message-ID: <53D5D527.30501@synopsys.com>
Date: Mon, 28 Jul 2014 10:14:23 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>
CC: Grant Likely <grant.likely@secretlab.ca>, <robh@kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: REVERT request for  patch "ARC: [arcfpga] stdout-path now suffices
 for earlycon/console" added to tty tree
References: <14050323662165@kroah.com>
In-Reply-To: <14050323662165@kroah.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Friday 11 July 2014 04:11 AM, gregkh@linuxfoundation.org wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>     ARC: [arcfpga] stdout-path now suffices for earlycon/console
> 
> to my tty git tree which can be found at
>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
> in the tty-next branch.
> 
> The patch will show up in the next release of the linux-next tree
> (usually sometime within the next 24 hours during the week.)
> 
> The patch will also be merged in the next major kernel release
> during the merge window.
> 
> If you have any questions about this process, please let me know.
> 
> 
>>From 9da433c0a0b5f71ac92dc9dca778295649675f08 Mon Sep 17 00:00:00 2001
> From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
> Date: Tue, 24 Jun 2014 13:55:15 +0530
> Subject: ARC: [arcfpga] stdout-path now suffices for earlycon/console
> 
> With recent improvements to serial/of core from Grant and Rob,
> stdout-path alone suffices for setting up earlycon/console.
> 
> arc_uart driver is already equipped to handle that, switch the DT now.
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/arc/boot/dts/angel4.dts | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arc/boot/dts/angel4.dts b/arch/arc/boot/dts/angel4.dts
> index 6b57475967a6..298a46daa633 100644
> --- a/arch/arc/boot/dts/angel4.dts
> +++ b/arch/arc/boot/dts/angel4.dts
> @@ -17,7 +17,8 @@
>  	interrupt-parent = <&intc>;
>  
>  	chosen {
> -		bootargs = "earlycon=arc_uart,mmio32,0xc0fc1000,115200n8 console=ttyARC0,115200n8";
> +		bootargs = "earlycon";
> +		stdout-path = &arcuart0;
>  	};
>  
>  	aliases {
> 

Could you please revert this single patch from tty-next for 3.17 as the needed
core changes are not yet finalized.

Thx and sorry for the trouble.

-Vineet
