Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbaCZMIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 08:08:14 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:43866 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaCZMIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:08:12 -0400
Message-ID: <5332C32A.5070301@linaro.org>
Date: Wed, 26 Mar 2014 13:08:10 +0100
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-acpi <linaro-acpi@lists.linaro.org>
Subject: RFC: APEI hardware reduced profile
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently APEI depends on x86 architecture. It is because of many x86 
specific features like "IA-32 Architecture Corrected Machine Check
" error source or NMI hardware error notification. However, many other 
features like "PCI Express Device AER Structure" or GHES via external 
interrupt can be still used perfectly by other architectures. So my idea 
is to move x86 dependency away form Kconfig to APEI areas where it 
really applies to.

I have started refactoring ghes.c driver in that direction. And here 
comes my confusion, how should we treat x86 related parts, as fixed 
profile? (which means we could use ACPI_REDUCED_HARDWARE or 
CONFIG_ACPI_REDUCED_HARDWARE_ONLY define). I would like to ask for your 
opinion.

Regards,
Tomasz
