Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbaBXOan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:30:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:11798 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752938AbaBXOal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:30:41 -0500
Date: Mon, 24 Feb 2014 09:30:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ktest: Set CLOSE_CONSOLE_SIGNAL in the kvm.conf
Message-ID: <20140224093039.6509b6cd@gandalf.local.home>
In-Reply-To: <8738jatylb.wl%satoru.takeuchi@gmail.com>
References: <8738jatylb.wl%satoru.takeuchi@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Feb 2014 10:19:28 +0900
Satoru Takeuchi <satoru.takeuchi@gmail.com> wrote:

> From: Satoru Takeuchi <satoru.takeuchi@gmail.com>
> 
> As mentioned at commit 5a5d8e48449, we can't terminate 'virsh console'
> with the default signal(INT). So it's better to set CLOSE_CONSOLE_SIGNAL
> in the kvm.conf.
> 
> Signed-off-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  tools/testing/ktest/examples/kvm.conf | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/tools/testing/ktest/examples/kvm.conf b/tools/testing/ktest/examples/kvm.conf
> index 831c7c5..40356f7 100644
> --- a/tools/testing/ktest/examples/kvm.conf
> +++ b/tools/testing/ktest/examples/kvm.conf
> @@ -10,6 +10,10 @@ MACHINE = Guest
>  # Use virsh to read the serial console of the guest
>  CONSOLE =  virsh console ${MACHINE}
>  
> +# Use SIGILL to terminate virsh console. We can't kill virsh console
> +# by the default signal, SIGINT.
> +CLOSE_CONSOLE_SIGNAL = KILL
> +

Thanks, I'll add this to my 3.15 queue.

-- Steve

>  #*************************************#
>  # This part is the same as test.conf  #
>  #*************************************#

