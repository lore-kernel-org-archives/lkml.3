Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbaI2SQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:16:24 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:64705 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbaI2SQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:16:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Olof Johansson <olof@lixom.net>, linux-ide@vger.kernel.org,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] ata: ahci_platform: Add ACPI support for AMD Seattle SATA controller
Date: Mon, 29 Sep 2014 20:16:05 +0200
Message-ID: <4070982.j4ECbq7XE2@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <542882E3.2050908@amd.com>
References: <1410295035-14471-1-git-send-email-suravee.suthikulpanit@amd.com> <CAOesGMh_Ku-pReg5LHVFvRM0-s_zEO4rgAvaD5rv-eTfPD71Yw@mail.gmail.com> <542882E3.2050908@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:KuUFS8FKXpmbrzNUyvAuaac0gdmnsRLAPCHhrYxIbOU
 EmtRKW6DPNvfRdCd7PZuPOfFEgLfj88ZX7xaKawFBGwoS6o4qX
 8/2uTlBvsSNTNDs2rKUTIA8Qu5kpoUmg8CZM6PYcrcoaPFx1zk
 u6UtNBGo1WiSRXNhQa93sPkqXWzKeV0XEkcf/BFGWFzIHSCDDD
 8ObBDuaM2ctJ1MAHpfYlfFpyRmseHdTt4NlNLjcdmS/PzJ+k2X
 kcmb7jCvA9ccZ5ER3g9ULjZCEAdXFiJtoxJM2JdtfJhRENl8/Z
 yBhzlEfC7jSVjiqfCnXZ/Fml7XT/jGGwT+eTN44AQS60bVGqU7
 XBr+Le94m8fQwxF3jMB0=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 September 2014 16:51:31 Suravee Suthikulpanit wrote:
> >> @@ -87,6 +90,13 @@ static const struct of_device_id ahci_of_match[] = {
> >>   };
> >>   MODULE_DEVICE_TABLE(of, ahci_of_match);
> >>
> >> +#ifdef CONFIG_ATA_ACPI
> >> +static const struct acpi_device_id ahci_acpi_match[] = {
> >> +       { "AMDI0600", 0 }, /* AMD Seattle AHCI */
> >> +       { },
> >> +};
> >> +#endif
> >> +

I just noticed this patch and stumbled over this hack. Since SBSA requires
any SATA support to be compatible with AHCI and not vendor specific, I think
this needs to be a more generic compatibility string that can be used by
all vendors, while the current one looks very AMD specific for hardware
that is not.

	Arnc
