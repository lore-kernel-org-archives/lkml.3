Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760321Ab3CHELE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 23:11:04 -0500
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:19572
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758903Ab3CHELB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 23:11:01 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Mar 2013 23:11:00 EST
X-Forefront-Antispam-Report: CIP:160.33.194.229;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail02v.am.sony.com;RD:mail.sonyusa.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z21eIz936eIzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275dhz2fh2a8h668h839h947hf0ah10d2h1288h12a5h12a9h12bdh137ah13b6h1441h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1b0ah1155h)
Message-ID: <51396143.5060108@am.sony.com>
Date: Thu, 7 Mar 2013 19:55:47 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <linux-rt-users@vger.kernel.org>
Subject: linux-3.6.11-rt30 smoke test on ARM
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-3.6.11-rt30 builds and boots on some ARM boards (PandaBoard, Realview) for:

  - SMP, PREEMPT_RT_FULL
  - SMP, PREEMPT_NONE
  - UP, PREEMPT_RT_FULL
  - UP, PREEMPT_NONE


The PandaBoard frequently fails to boot with an eth0 error.  I have
only seen this for SMP, PREEMPT_NONE.  This same error also occurs
in 3.6.7 without the RT_PREEMPT patches applied, so this does not
appear to be an RT_PREEMPT issue.

This error also occurred in the previous smoke test of linux-3.6.7-rt18

   http://permalink.gmane.org/gmane.linux.rt.user/9202

The boot error starts with the USB time out on ep0out:

[    3.264373] smsc95xx 1-1.1:1.0: usb_probe_interface
[    3.269500] smsc95xx 1-1.1:1.0: usb_probe_interface - got id
[    3.275543] smsc95xx v1.0.4
[    8.078674] smsc95xx 1-1.1:1.0: eth0: register 'smsc95xx' at usb-ehci-omap.0-1.1, smsc95xx USB 2.0 Ethernet, 82:b9:1d:fa:67:0d
[    8.091003] hub 1-1:1.0: state 7 ports 5 chg 0000 evt 0002
[   13.509918] usb 1-1.1: swapper/0 timed out on ep0out len=0/4
[   13.515869] smsc95xx 1-1.1:1.0: eth0: Failed to write register index 0x00000108
[   13.523559] smsc95xx 1-1.1:1.0: eth0: Failed to write ADDRL: -110
[   13.529998] IP-Config: Failed to open eth0


The boot error can be avoided with a workaround that simply retries
the failed USB command.  I will reply to this email with the patch.

-Frank

