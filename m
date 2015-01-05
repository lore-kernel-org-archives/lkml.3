Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbbAEK05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:26:57 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:52446 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbbAEK0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:26:55 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: "Zheng\, Lv" <lv.zheng@intel.com>
Cc: "linux-acpi\@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel\@acpica.org" <devel@acpica.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ACPICA: Remove use of __DATE__ macro
Organization: D03
References: <1418381488-25123-1-git-send-email-linux@rasmusvillemoes.dk>
	<1418381488-25123-3-git-send-email-linux@rasmusvillemoes.dk>
	<1AE640813FDE7649BE1B193DEA596E88026AACD9@SHSMSX101.ccr.corp.intel.com>
X-Hashcash: 1:20:150105:linux-kernel@vger.kernel.org::zOqhYgyyJc+off9D:0000000000000000000000000000000000N2X
X-Hashcash: 1:20:150105:lv.zheng@intel.com::HixxxO40o7VukCvg:000000000000000000000000000000000000000000017Jd
X-Hashcash: 1:20:150105:devel@acpica.org::fj3JPl3RykNvbZRh:01obk
X-Hashcash: 1:20:150105:linux-acpi@vger.kernel.org::MUtlccU/9MFkbE77:000000000000000000000000000000000005luD
Date: Mon, 05 Jan 2015 11:26:52 +0100
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88026AACD9@SHSMSX101.ccr.corp.intel.com>
	(Lv Zheng's message of "Mon, 5 Jan 2015 08:47:43 +0000")
Message-ID: <87oaqdy13n.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05 2015, "Zheng, Lv" <lv.zheng@intel.com> wrote:

> Hi,
>
>> From: Rasmus Villemoes [mailto:linux@rasmusvillemoes.dk]
>> Sent: Friday, December 12, 2014 6:51 PM
>> To: Zheng, Lv
>> Cc: Rasmus Villemoes; linux-acpi@vger.kernel.org; devel@acpica.org; linux-kernel@vger.kernel.org
>> Subject: [PATCH 3/3] ACPICA: Remove use of __DATE__ macro
>> 
>> The macro __DATE__ and friends is not allowed in the kernel. Also,
>> including the build time in output doesn't seem to provide any value.
>> 
>
> Could you confirm that it is not useful even for the user tools?
> Please perform the following commands in the kernel source tree
> 1. stay in tools folder
> 2. type "make acpi"
> 3. type "./power/acpi/acpidump -v"
>

Yeah, it's part of the output, but for what reason? What can userspace
possibly use that information for? I can see some utility in printing a
version number, since that may tell something about the features
present or absent. The compilation date, on the other hand, seems
completely useless. Different distros may ship different versions which
happened to be compiled on the same day, or older versions compiled later.

Note that -Werror=date-time was added to the kernel's default build
flags in fe7c36c7bde12. It doesn't currently show because tools/ uses
its own flags, and the ACPI_COMMON_SIGNON macro is not used within the
kernel. 

Rasmus
