Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaJaQsw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:48:52 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:52606 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbaJaQsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:48:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Matthias Brugger <matthias.bgg@gmail.com>, gregkh@linuxfoundation.org,
        heiko@sntech.de, yingjoe.chen@gmail.com, linux-kernel@vger.kernel.org,
        ibanezchen@gmail.com, linux-serial@vger.kernel.org, jslaby@suse.cz,
        alan@linux.intel.com
Subject: Re: [PATCH RESEND] tty: serial: 8250_mtk: Fix quot calculation
Date: Fri, 31 Oct 2014 17:48:14 +0100
Message-ID: <9001280.dDNTE2ykLV@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1414773395-9916-1-git-send-email-matthias.brugger@bq.com>
References: <1414773395-9916-1-git-send-email-matthias.brugger@bq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:blnOh06Pm/lDdAeuRTmWSVay3Lp1YIC1Lf9kQCxBpoB
 w3dBedHaLlKUXGtglZu1D1z/9JWISE6rWV1053EPTJk+2FKFco
 2J9yGZq1s0qsaDxNg4JfvfrMzT3lUY5R1dwOX6iFYA9LtWIeLd
 KbcmhjY+HKbZH+vAVLN/7BHkItGXhlz2dorQClMADGSkF3YrhR
 8aIMtu7I5669NKQj0EKOuvKLBEyZQbWTV21Kkk2IY7WfXNr48x
 JA+oGdvykqA3U2vb+RTQG6BgyVAgoJuzmyJepE4RFoC99m43IK
 2QUwJ58u7VD7br+/PL1MpOgvj6PuUID4DMGzRzIgf9ZJen0KqV
 GD4NA+P0wsshF3z3vih4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 October 2014 17:36:35 Matthias Brugger wrote:
> -               quot = DIV_ROUND_CLOSEST(port->uartclk, 256 * baud);
> +               quot = (port->uartclk / (256 * baud)) + 1;

Should this be DIV_ROUND_UP then?

	Arnd
