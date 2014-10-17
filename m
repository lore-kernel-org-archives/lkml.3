Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaJQMEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 08:04:05 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52425 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752721AbaJQMDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:03:36 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v5 00/12] Add ACPI _DSD and unified device properties support
Date: Fri, 17 Oct 2014 14:01:33 +0200
Message-ID: <11223831.j9KAEfSQsY@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2660541.BycO7TFnA2@vostro.rjw.lan>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everyone,

Hving had a couple of chats with Grant and Arnd during LinuxCon EU/LPC, we
now have version 5 taking all feedback into account (hopefully).

Changes have been made to patch [02/12] and to patches [09-12/12], although
in patches [10-12/12] they are fairly minor.  I have retained the Greg's
ACK on patch [02/12], because it is essentially the same that have been
posted aleady and ACKed by him (Greg, please let me know if I shouldn't
do that) and all the ACKs on the remaining patches except for patch [09/12]
which is substantially different.  Still, if reviewers think that their
ACKs don't apply any more, please let me know and I'll remove them.

Patch [02/12] now contains helper functions for all proprerty data types
that can be accessed which call the existing of_ functions, because Grant
preferred that.

Patch [09/12] introduces quite a new concept, which is the struct fwnode_handle
structure containing one field (type) and embedded in struct device_node
(type==FWNODE_OF) and struct acpi_device (type==FWNODE_ACPI).  In short, if
we are passed a struct fwnode_handle pointer, we can get from it to the
appropriate device node pointer (either struct acpi_device or struct device_node)
using container_of() after we've checked the type.  This is needed for the code
that needs to access child nodes of a device in case when they don't have
struct device representations (whatever the reason).  This has been suggested
by Grant and pretty much everyone involved agrees that it's better that the
alternatives presented so far.

For completeness, the previous cover letter is appended below.

Rafael


On Tuesday, October 07, 2014 02:10:56 AM Rafael J. Wysocki wrote:
> Hi Everyone,
> 
> This is version 4 of the unified device properties interface patchset.
> 
> The original cover letter from Mika is here:
> 
> http://marc.info/?l=devicetree&m=141087052200600&w=4
> 
> My cover letter for version 3 is here:
> 
> http://marc.info/?l=linux-acpi&m=141212903816560&w=4
> 
> One major change from the previous iteration is that now we will
> use the "compatible" property to match drivers to devices having
> "PRP0001" as their _HID, so for example the at25 driver doesn't
> have to add the extra ACPI match table as part of the conversion
> to the unified interface (patch [05/13] in this series).
> 
> The second major change is that I've split the driver core patch
> in two, where the first one ([02/13]) does not contain any stuff
> related to iterating over the child nodes of a given device.
> Accordingly, the whole patch series has been rearranged so that
> the relatively non-controversial patches [01-09/13], most of which
> have been ACKed already, go first and then goes the second driver
> core patch ([10/13]) and the other patches related to it.
> 
> In patches [10-13/13] I used the Arnd's suggestion to implement
> device_for_each_child_node() as a macro which makes the changes
> in patches [12-13/13] look more straightforward among other things.
> 
> I've retained the Greg's ACKs on patches [02/13] and [10/13], because
> the first of them is things ACKed by Greg only and the change in the
> second one is just an implementation detail in my opinion (Greg, please
> let me know if that's inappropriate).
> 
> Thanks!
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
