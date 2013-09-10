Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3IJDxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 23:53:07 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42146 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab3IJDxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 23:53:04 -0400
Message-ID: <522E978C.6040506@gentoo.org>
Date: Mon, 09 Sep 2013 23:52:44 -0400
From: Jonathan Callen <jcallen@gentoo.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130811 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: Move acpi_bus_get_device() from bus.c to scan.c
References: <3314440.iryh4ZRtRb@vostro.rjw.lan>
In-Reply-To: <3314440.iryh4ZRtRb@vostro.rjw.lan>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 07/27/2013 09:24 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com> Subject: ACPI: Move acpi_bus_get_device()
> from bus.c to scan.c
> 
> Move acpi_bus_get_device() from bus.c to scan.c which allows acpi_bus_data_handler() to become
> static and clean up the latter.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com> --- drivers/acpi/bus.c      |
> 21 --------------------- drivers/acpi/scan.c     |   30 ++++++++++++++++++++++-------- 
> include/acpi/acpi_bus.h |    1 - 3 files changed, 22 insertions(+), 30 deletions(-)
> 
> Index: linux-pm/drivers/acpi/bus.c 
> =================================================================== ---
> linux-pm.orig/drivers/acpi/bus.c +++ linux-pm/drivers/acpi/bus.c @@ -89,27 +89,6 @@ static
> struct dmi_system_id dsdt_dmi_tab Device Management
[cut]
> - -EXPORT_SYMBOL(acpi_bus_get_device); - acpi_status acpi_bus_get_status_handle(acpi_handle
> handle, unsigned long long *sta) { Index: linux-pm/drivers/acpi/scan.c 
> =================================================================== ---
> linux-pm.orig/drivers/acpi/scan.c +++ linux-pm/drivers/acpi/scan.c @@ -970,6 +970,28 @@ struct
> bus_type acpi_bus_type = { .uevent		= acpi_device_uevent, };
> 
[cut]
> +} +EXPORT_SYMBOL_GPL(acpi_bus_get_device); +

Was it intentional to change the EXPORT_SYMBOL to EXPORT_SYMBOL_GPL here?  While I understand that
it is completely unsupported anyway, this change does break at least the latest version of the
proprietary nvidia graphics driver.

- -- 
Jonathan Callen
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJSLpeMAAoJELHSF2kinlg4EGEP/2lav3ETWSAs7BqeDGCuacZ4
CqkWJlMJDvYawW443KdBEb8aM27tx+gqNp+ktHkWXuXG97X79yAVTRMggOCuaqkb
AgYJkDXRY+64UWtn2GeCM4vSsBOB86UoSspdZXHzF6JBDXrdd2ZXkpb1q7u1xBdi
SZIz3PxZmBLMVcxu+Bh67e1hRXbxKxfKlF1Zl7MC/9NDnxkZmrOklqY2VamG864a
OkFU12bvgdGCwOnq1gHzDjt2PIjL7RNxY4wPWvnyJ1DDOi2tb5tC7hw8VoUTqUPx
h81QmAY2T/XFWTpfNnmJgrQYw+AE8B1TNz+ciKWRi0VCAAjYdomPCYfjxnfYBvN2
a1RRAUMG7DFOZxzBNE9Yv371zEAKLAt2Kbt5PynSqTiivRu7XJOpz5326Q1P9Csy
HZ369Gu7oC2ErAEv3mO82do5pM6/10DpwFPhY5eGq8l7rdStk8cRdUW1Ivc/d0sx
CDt0ZDVV+bvtduwnMTRiXWIgR2w/iUuNcwU5RfU/2NsJLyXeUoMdR0OHLa1sDSVk
bK3Jc6AAPQG8aV83Je50eFeYUQgYN9DZ2eRR+KtzBFaI4TXXzq3H+1E5QBBqbfc8
6PZuVC+CwMYmmhsozvkyyKIdYVJL0KiWOgaZueNq6Z2Fqiupr4BrMpKvS1rkix4y
Pn0TU7V4arGbXGzJN1VZ
=SHrw
-----END PGP SIGNATURE-----
