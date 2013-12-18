Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab3LRIEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 03:04:55 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:53188 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab3LRIEy convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Wed, 18 Dec 2013 03:04:54 -0500
Message-Id: <52B16533020000780010E890@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 18 Dec 2013 08:04:51 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Tony Luck" <tony.luck@intel.com>
Cc: "Matt Fleming" <matt.fleming@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] don't select EFI from certain special ACPI drivers
References: <52AF1EBC020000780010DBF9@nat28.tlf.novell.com>
 <3908561D78D1C84285E8C5FCA982C28F31D8A4C2@ORSMSX106.amr.corp.intel.com>
 <52B013E8020000780010E009@nat28.tlf.novell.com>
 <3908561D78D1C84285E8C5FCA982C28F31D8B8CE@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D8B8CE@ORSMSX106.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.12.13 at 23:34, "Luck, Tony" <tony.luck@intel.com> wrote:
>>  No, it hasn't. But I explicitly checked the relevant EFI=n and EFI=y
>> cases.
> 
> I pushed your patch into my "next" tree - the robots will notice soon and 
> send us e-mail if they find any issues.

Thanks, Tony. I'm afraid though that fixing this only in 3.14 would
be a little late: Any "select" in a Kconfig results in the user not being
asked again when that "select" goes away, so people having got EFI
forcibly enabled in 3.13 and updating their configs to 3.14 would
then need to remember to manually disable CONFIG_EFI again (of
course that's already true for anyone using 3.13-rc?, but those
should mostly be people more knowledgeable than folks just
consuming final releases).

I think it should generally be the exception to "select" options that
have visible prompts (i.e. are user configurable).

Jan

