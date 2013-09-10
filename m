Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab3IJWxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:53:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45388 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab3IJWxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:53:44 -0400
Message-ID: <522FA2A8.8080703@zytor.com>
Date: Tue, 10 Sep 2013 15:52:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org, akpm@linux-foundation.org,
        zohar@linux.vnet.ibm.com, d.kasatkin@samsung.com,
        ebiederm@xmission.com, matthew.garrett@nebula.com,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 15/16] bootparam: Pass acpi_rsdp pointer in bootparam
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com> <1378849471-10521-16-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1378849471-10521-16-git-send-email-vgoyal@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 02:44 PM, Vivek Goyal wrote:
> Currently kexec does not enables EFI and its tables in second kernel. Hence
> acpi rsdp root pointer is passed on command line. But secureboot does not trust
> acpi_rsdp on command line as kernel can execute some of the code as retrieved
> by following acpi_rsdp and root can modify command line. So in secureboot
> mode we ignore acpi_rsdp on command line.
> 
> Start passing it in bootparams for the time being. kexec-tools will prepare
> the bootparams and put acpi_rsdp pointer there.
> 
> Peter Jones suggested that scan all ACPI memory for acpi_rsdp if EFI is
> not enabled. This probably is a better fix and most likely this patch will
> change and adopt that approach down the line.
> 
> In fact if we figure out how to make UEFI run time calls in second kernel,
> we will not need acpi_rsdp at all.
> 

Borislav Petkov has been working on a fixed mapping of UEFI memory,
which should allow UEFI runtime calls across kexec.

	-hpa


