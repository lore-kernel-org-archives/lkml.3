Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbaGLIPG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 04:15:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaGLIO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 04:14:59 -0400
Date: Sat, 12 Jul 2014 01:18:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] reformat_with_checkpatch: Add automation to checkpatch
Message-ID: <20140712081837.GA28704@kroah.com>
References: <1405128087.6751.12.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405128087.6751.12.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 06:21:27PM -0700, Joe Perches wrote:
> A simple script to run checkpatch --fix for various types of
> of cleanups.
> 
> This script is useful primarily for staging.
> 
> This reformats code to a more CodingStyle conforming style,
> compiles it, verifies that the object code hasn't changed,
> and git commits it too.
> 
> You must have the necessary development tools, git, and a
> recent git tree.  Ideally use Greg KH's staging-next, which
> can be retrieved via these commands:
> 
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
> git checkout staging-next
> 
> To use this script try a sequence of commands like:
> 
> 	cd <linux_repository>
> 	git checkout -b <your_branch>
> 	make allyesconfig
> 	mkdir patches
> 	./scripts/reformat_with_checkpatch.sh drivers/staging/<dir>/*.[ch]
> 	git format-patch --cover-letter -o patches/<your_branch> staging-next
> 	git send-email patches/<your_branch>

When running this on drivers/base/bus.c, it says that the .o files are
different, when the diffstat for what makes them different is only
whitespace.

I did the following:

$ scripts/reformat_with_checkpatch.sh drivers/base/bus.c

Ignore the first set of things it tries to commit by answering N to the
"Would you like to commit these changes".

Then the second thing it tries to change in the file says that there is
a .o file difference.

Yet the diff is below, I don't see how this happens.  Is this due to
there being some old temp file around because I did not accept the first
set of changes?

thanks,

greg k-h

-------------
diff:

 drivers/base/bus.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 83e910a57563..3546d02b46f0 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -32,7 +32,6 @@ static struct kset *system_kset;
 
 #define to_drv_attr(_attr) container_of(_attr, struct driver_attribute, attr)
 
-
 static int __must_check bus_rescan_devices_helper(struct device *dev,
 						void *data);
 
@@ -128,6 +127,7 @@ static const struct sysfs_ops bus_sysfs_ops = {
 int bus_create_file(struct bus_type *bus, struct bus_attribute *attr)
 {
 	int error;
+
 	if (bus_get(bus)) {
 		error = sysfs_create_file(&bus->p->subsys.kobj, &attr->attr);
 		bus_put(bus);
@@ -817,6 +817,7 @@ EXPORT_SYMBOL_GPL(device_reprobe);
 struct bus_type *find_bus(char *name)
 {
 	struct kobject *k = kset_find_obj(bus_kset, name);
+
 	return k ? to_bus(k) : NULL;
 }
 #endif  /*  0  */

--------------


What the script complained about:

Comparing objects...
--- drivers/base/bus.o.new	2014-07-12 01:16:32.984755945 -0700
+++ drivers/base/bus.o.old	2014-07-12 01:16:31.924755967 -0700
@@ -2449,13 +2449,13 @@
 
 0000000000000000 <descriptor.17493>:
 	...
-:	bf 03 00 00 00       	mov    $0x3,%edi
+:	be 03 00 00 00       	mov    $0x3,%esi
 :	00 00                	add    %al,(%rax)
 	...
 
 0000000000000028 <descriptor.17483>:
 	...
-:	a2 03 00 00 00 00 00 	movabs %al,0x3
+:	a1 03 00 00 00 00 00 	movabs 0x3,%eax
 :	00 00 
 
 0000000000000050 <descriptor.17406>:
@@ -2468,7 +2468,7 @@
 
 0000000000000078 <descriptor.17073>:
 	...
-:	56                   	push   %rsi
+:	57                   	push   %rdi
 :	00 00                	add    %al,(%rax)
 :	00 00                	add    %al,(%rax)
 :	00 00                	add    %al,(%rax)
Object differences exist! - Verify changes before commit!


