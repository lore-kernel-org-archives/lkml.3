Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3AROxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 09:53:35 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58235 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930Ab3AROxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 09:53:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 50/76] ARC: SMP support
Date: Fri, 18 Jan 2013 14:53:29 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Rajeshwar Ranga <rajeshwar.ranga@gmail.com>,
        Noam Camus <noamc@ezchip.com>,
        "Gilad Ben-Yossef" <gilad@benyossef.com>
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-51-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358511930-7424-51-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181453.29243.arnd@arndb.de>
X-Provags-ID: V02:K0:MG0fBp9rJ+CrXMm1oX8wkiqM9vHhFIrdEd50pecicin
 PLnxyy2wHnyZUvs6yvO6Vpcrk7L2/53d76vdeFrtm0q10xh5Nn
 Gkk2WOkk7rOBxLLgY765vFkOjJI74k/gTV3vgfl7lZRkpD/1cV
 lovdkUz38laHiTo88rDYmwIVBb/thA9IHxHOuOJJ/KEus80bcd
 lyeFc9ZhFywxL8VRCoI85DsKbq7tLSqgTizMJVlG7AiXLDH9nx
 lwuaLdrSOb1DrxS79ea3BfBYzDe/KIGlzbKmoChib/S8bbVa2Q
 IN+xszMJx5LNvY+BYrs14bgJzPsVOfmnlY7uVSQkyM4Bn0wu0I
 IuAULj6TeMAkI0wlklxg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Vineet Gupta wrote:
> +# If a plat can do IPI, same core(s) can do minimal SMP
> +config ARC_HAS_IPI
> +       bool
> +

I think it would be better to turn the logic around here,
otherwise you get into trouble when enabling multiple
platforms, out of which some have IPI support and others
don't.

Instead, you can mark the platforms that lack IPI support
(or multiple CPUs) as 'depends on !SMP'.

	Arnd
