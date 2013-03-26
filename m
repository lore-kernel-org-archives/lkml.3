Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab3CZLII (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 07:08:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49728 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab3CZLIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 07:08:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: fixes for 3.9-rc #2
Date: Tue, 26 Mar 2013 11:05:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
References: <51517592.5010300@atmel.com> <201303261022.39882.arnd@arndb.de> <51517EEB.7030709@atmel.com>
In-Reply-To: <51517EEB.7030709@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303261105.22173.arnd@arndb.de>
X-Provags-ID: V02:K0:BHhbyiHUuh8vmf/WTtqnTFRwJupb3KAK16dYnWoaHEp
 0Xchtf1saFqrej+K1pyse51TC26NpolZ2KU6RnLSqUylyw/pTe
 xsqDbItzF15C1UBLNAAMFTPW+zWsBwFvszWIqORteJqYJUo4Q7
 1dGOYGYxFoZ7eDaeconkCv1E5Xmw9MsmxlETzK2RPPLophoM7T
 hjjCWC9PBENFfAF3ITC01TnP5L0jrtWGGElho915hyVblOW+ft
 x4eTGuTyP0KlIb9dzr8X7ntkCPmf8D5izotbfCs9dg3fFY40jE
 yyfBakUUHG0nVPpOa2PD3BsI6dgqeccD5FLoWzGlTEuTPC0DLf
 /VygwimyMasKTAdVN9pc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 March 2013, Nicolas Ferre wrote:
> Indeed, at first sight its looks like a nice solution. But I wonder if
> we add several nodes in this kind of .dtsi files, we may end up with
> mess between APB peripherals and board specific ones like leds, NAND, etc.
> Moreover, the plain and full naming of the node makes it identifiable
> without doubts, even someone not completely familiar with DT.
> 
> I slightly prefer to keep it like this, but I can still change my mind ;-)

If you don't want to use the labels, it's probably better to drop from
the dtsi files. I think you can also write 

ahb/apb/ethernet@802c000 {
	phy-mode = "rmii";
        status = "okay";
};

although I think most people prefer the labels, and I have not tried
the above.

Back to the bug fix, I think we can have a simpler version for 3.9
if you just mark the ethernet node as "disabled" in the 
at91sam9g15.dtsi file, and then do the patch to change the default
in an add-on patch for 3.10.

	Arnd
