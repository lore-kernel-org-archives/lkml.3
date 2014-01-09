Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbaAIWs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 17:48:57 -0500
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:51172 "HELO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751751AbaAIWsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 17:48:54 -0500
MIME-Version: 1.0
In-Reply-To: <201401082243.01694.arnd@arndb.de>
References: <1389135041-16062-1-git-send-email-fkan@apm.com>
	<1389135041-16062-6-git-send-email-fkan@apm.com>
	<201401082243.01694.arnd@arndb.de>
Date: Thu, 9 Jan 2014 14:48:52 -0800
Message-ID: <CAL85gmB4erJ8C=YYysXuLaY9Tkr79Z=7pAgrv0JuSU+bkxwaxg@mail.gmail.com>
Subject: Re: [PATCH V2 5/6] power: reset: change xgene reboot driver to use
 both acpi and dts resource for reboot.
From: Feng Kan <fkan@apm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 1:43 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 07 January 2014, Feng Kan wrote:
>> Enable the X-Gene reboot driver to use either the ACPI or the DTS
>> resource using the platform driver method.
>>
>> Signed-off-by: Feng Kan <fkan@apm.com>
>> ---
>>  drivers/power/reset/xgene-reboot.c |   33 ++++++++++++++++++++++++++++-----
>>  1 files changed, 28 insertions(+), 5 deletions(-)
>>
>
> Shouldn't an ACPI based system always be able to reboot through the
> UEFI reset_system call? I really don't think we want to support
> ACPI on non-UEFI systems.
>
>         Arnd
Thanks Arnd, I will retract the ACPI support for now. We are still
trying to figure
out how best to support ACPI. The larger problem seems to be the fact that
UEFI and ACPI were originally made for x86 and is ill suited for the
arm64. I will
see if I can find a better path for this patch.
