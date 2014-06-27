Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbaF0JIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 05:08:11 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:58017 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbaF0JIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 05:08:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>, linux-acpi@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>, lorenzo.pieralisi@arm.com,
        rric@kernel.org, Al Stone <al.stone@linaro.org>,
        linaro-acpi@lists.linaro.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Charles.Garcia-Tobin@arm.com
Subject: Re: [PATCH v4 06/13] ARM64 / ACPI: Introduce early_param for "acpi"
Date: Fri, 27 Jun 2014 11:07:48 +0200
Message-ID: <23398804.v8nA0xfjOe@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1403840976-7456-7-git-send-email-hanjun.guo@linaro.org>
References: <1403840976-7456-1-git-send-email-hanjun.guo@linaro.org> <1403840976-7456-7-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:czLn03MX/kafZgIweLEvsav//JOJXi/RWZ4uGYhWRs8
 jGiG82TDhrs+I0luZ1LmX0dv7cGxZyRZ5C4xYNAtzElAKXHmqH
 CDORZluNspkEoRoj+Hul96dVVHiE5io+BXHSpVFMbVObcgc14N
 2yYF3VBP9PTrnut9E/Qik9O18adNtrBpu8T+NYFybdFFYJDdNQ
 FLdanrh5ixTHwpNBJxY9nn1a9qIB87j9CcvXSGz+ggSv0uzIjr
 iNdDxgefyPxIKxZvlJh0uI1plJV0lSw2jbW4xGOIWF9XmT5qLU
 PyKjIpccxwiVMxzYCDANco+6OEOisIdWnbFb2VjsBsTuPD4/+S
 SH1fYgonjlK2cnrDTBkk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 June 2014 11:49:29 Hanjun Guo wrote:
> +
> +static int __init parse_acpi(char *arg)
> +{
> +       if (!arg)
> +               return -EINVAL;
> +
> +       /* "acpi=off" disables both ACPI table parsing and interpreter */
> +       if (strcmp(arg, "off") == 0) {
> +               disable_acpi();
> +       }
> +       /* acpi=strict disables out-of-spec workarounds */
> +       else if (strcmp(arg, "strict") == 0) {
> +               acpi_strict = 1;
> +       } else {
> +               /* Core will printk when we return error */
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +early_param("acpi", parse_acpi);

Can you explain in the changelog what happens for the acpi=off case? Does this
mean we fall back to using data from the dtb instead, or will it just not work?

If I understand correctly, this option makes sense on PC systems that will
still be able to boot using the legacy BIOS services and implicit assumptions
about the hardware, but that never works on arm64.

	Arnd
