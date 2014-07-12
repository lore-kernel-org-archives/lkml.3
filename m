Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaGLKNg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 06:13:36 -0400
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:50850 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752305AbaGLKNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 06:13:34 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:1:41:355:379:421:541:599:960:966:968:973:982:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:2196:2197:2198:2199:2200:2201:2393:2538:2553:2559:2562:2637:2828:2898:2911:2915:3138:3139:3140:3141:3142:3622:3653:3855:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4385:4425:4605:4823:5007:6119:6691:7652:7875:7903:7904:7974:8660:8784:9010:9040:9121:9592:10004:10848:11026:11232:11233:11473:11658:11914:12043:12114:12295:12296:12438:12517:12519:12555:12679:12740:13148:13161:13180:13184:13229:13230:14096:
X-HE-Tag: sense99_1aa924c8975f
X-Filterd-Recvd-Size: 12933
Message-ID: <1405160008.9132.7.camel@joe-AO725>
Subject: Re: [PATCH] reformat_with_checkpatch: Add automation to checkpatch
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Sat, 12 Jul 2014 03:13:28 -0700
In-Reply-To: <20140712081837.GA28704@kroah.com>
References: <1405128087.6751.12.camel@joe-AO725>
	 <20140712081837.GA28704@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-12 at 01:18 -0700, Greg KH wrote:
> On Fri, Jul 11, 2014 at 06:21:27PM -0700, Joe Perches wrote:
> > A simple script to run checkpatch --fix for various types of
> > of cleanups.
[]
> I did the following:
> 
> $ scripts/reformat_with_checkpatch.sh drivers/base/bus.c
> 
> Ignore the first set of things it tries to commit by answering N to the
> "Would you like to commit these changes".
> 
> Then the second thing it tries to change in the file says that there is
> a .o file difference.
> 
> Yet the diff is below, I don't see how this happens.  Is this due to
> there being some old temp file around because I did not accept the first
> set of changes?

[]

> What the script complained about:
> 
> Comparing objects...
> --- drivers/base/bus.o.new	2014-07-12 01:16:32.984755945 -0700
> +++ drivers/base/bus.o.old	2014-07-12 01:16:31.924755967 -0700
> @@ -2449,13 +2449,13 @@
>  
>  0000000000000000 <descriptor.17493>:
>  	...
> -:	bf 03 00 00 00       	mov    $0x3,%edi
> +:	be 03 00 00 00       	mov    $0x3,%esi
>  :	00 00                	add    %al,(%rax)
>  	...
>  
>  0000000000000028 <descriptor.17483>:
>  	...
> -:	a2 03 00 00 00 00 00 	movabs %al,0x3
> +:	a1 03 00 00 00 00 00 	movabs 0x3,%eax
>  :	00 00 
>  
>  0000000000000050 <descriptor.17406>:
> @@ -2468,7 +2468,7 @@
>  
>  0000000000000078 <descriptor.17073>:
>  	...
> -:	56                   	push   %rsi
> +:	57                   	push   %rdi
>  :	00 00                	add    %al,(%rax)
>  :	00 00                	add    %al,(%rax)
>  :	00 00                	add    %al,(%rax)
> Object differences exist! - Verify changes before commit!
> 
> 

I've no real idea, but this looks more like
non-repeatable gcc compilation output to me.

Here's my script output from that sequence.

$ gcc --version
gcc (Ubuntu 4.8.2-19ubuntu1) 4.8.2
Copyright (C) 2013 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ scripts/reformat_with_checkpatch.sh drivers/base/bus.c
file: <drivers/base/bus.c> description: <whitespace neatening> types:<spacing,space_before_tab,pointer_location,trailing_whitespace,bracket_space>
total: 0 errors, 0 warnings, 0 checks, 1272 lines checked

NOTE: Used message types: BRACKET_SPACE POINTER_LOCATION SPACE_BEFORE_TAB SPACING TRAILING_WHITESPACE

drivers/base/bus.c has no obvious style problems and is ready for submission.
file: <drivers/base/bus.c> description: <remove spaces before tabs> types:<space_before_tab>
total: 0 errors, 0 warnings, 0 checks, 1272 lines checked

NOTE: Used message types: SPACE_BEFORE_TAB

drivers/base/bus.c has no obvious style problems and is ready for submission.
file: <drivers/base/bus.c> description: <fix label positions> types:<indented_label>
total: 0 errors, 0 warnings, 0 checks, 1272 lines checked

NOTE: Used message types: INDENTED_LABEL

drivers/base/bus.c has no obvious style problems and is ready for submission.
file: <drivers/base/bus.c> description: <align arguments to parenthesis> types:<parenthesis_alignment>
CHECK: Alignment should match open parenthesis
#37: FILE: drivers/base/bus.c:37:
+static int __must_check bus_rescan_devices_helper(struct device *dev,
+						void *data);

CHECK: Alignment should match open parenthesis
#518: FILE: drivers/base/bus.c:518:
+		error = sysfs_create_link(&bus->p->devices_kset->kobj,
+						&dev->kobj, dev_name(dev));

CHECK: Alignment should match open parenthesis
#522: FILE: drivers/base/bus.c:522:
+		error = sysfs_create_link(&dev->kobj,
+				&dev->bus->p->subsys.kobj, "subsystem");

CHECK: Alignment should match open parenthesis
#701: FILE: drivers/base/bus.c:701:
+		printk(KERN_ERR "%s: uevent attr (%s) failed\n",
+			__func__, drv->name);

CHECK: Alignment should match open parenthesis
#707: FILE: drivers/base/bus.c:707:
+		printk(KERN_ERR "%s: driver_create_groups(%s) failed\n",
+			__func__, drv->name);

CHECK: Alignment should match open parenthesis
#715: FILE: drivers/base/bus.c:715:
+			printk(KERN_ERR "%s: add_bind_files(%s) failed\n",
+				__func__, drv->name);

CHECK: Alignment should match open parenthesis
#1003: FILE: drivers/base/bus.c:1003:
+					int (*compare)(const struct device *a,
+							const struct device *b))

total: 0 errors, 0 warnings, 7 checks, 1272 lines checked

NOTE: Used message types: PARENTHESIS_ALIGNMENT

Wrote EXPERIMENTAL --fix correction(s) to 'drivers/base/bus.c'

Do _NOT_ trust the results written to this file.
Do _NOT_ submit these changes without inspecting them for correctness.

This EXPERIMENTAL file is simply a convenience to help rewrite patches.
No warranties, expressed or implied...

drivers/base/bus.c has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.
Compiling original version...
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --silentoldconfig Kconfig
  CHK     include/config/kernel.release
make[1]: `all' is up to date.
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/generated/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CC      drivers/base/bus.o
patching file drivers/base/bus.c
Compiling modified version...
  CHK     include/config/kernel.release
make[1]: `all' is up to date.
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CC      drivers/base/bus.o
Comparing objects...
No object differences found
running checkpatch on possible checkpatch fixes...
WARNING: line over 80 characters
#27: FILE: drivers/base/bus.c:522:
+					  &dev->bus->p->subsys.kobj, "subsystem");

drivers/base/bus.c.diff has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.
Verify checkpatch output and make any necessary changes
Edit 'drivers/base/bus.c' if appropriate
Press the 'enter' key to continue: diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 83e910a..a9d5825 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -34,7 +34,7 @@ static struct kset *system_kset;
 
 
 static int __must_check bus_rescan_devices_helper(struct device *dev,
-						void *data);
+						  void *data);
 
 static struct bus_type *bus_get(struct bus_type *bus)
 {
@@ -515,11 +515,11 @@ int bus_add_device(struct device *dev)
 		if (error)
 			goto out_groups;
 		error = sysfs_create_link(&bus->p->devices_kset->kobj,
-						&dev->kobj, dev_name(dev));
+					  &dev->kobj, dev_name(dev));
 		if (error)
 			goto out_id;
 		error = sysfs_create_link(&dev->kobj,
-				&dev->bus->p->subsys.kobj, "subsystem");
+					  &dev->bus->p->subsys.kobj, "subsystem");
 		if (error)
 			goto out_subsys;
 		klist_add_tail(&dev->p->knode_bus, &bus->p->klist_devices);
@@ -698,13 +698,13 @@ int bus_add_driver(struct device_driver *drv)
 	error = driver_create_file(drv, &driver_attr_uevent);
 	if (error) {
 		printk(KERN_ERR "%s: uevent attr (%s) failed\n",
-			__func__, drv->name);
+		       __func__, drv->name);
 	}
 	error = driver_add_groups(drv, bus->drv_groups);
 	if (error) {
 		/* How the hell do we get out of this pickle? Give up */
 		printk(KERN_ERR "%s: driver_create_groups(%s) failed\n",
-			__func__, drv->name);
+		       __func__, drv->name);
 	}
 
 	if (!drv->suppress_bind_attrs) {
@@ -712,7 +712,7 @@ int bus_add_driver(struct device_driver *drv)
 		if (error) {
 			/* Ditto */
 			printk(KERN_ERR "%s: add_bind_files(%s) failed\n",
-				__func__, drv->name);
+			       __func__, drv->name);
 		}
 	}
 
@@ -1000,7 +1000,7 @@ EXPORT_SYMBOL_GPL(bus_get_device_klist);
  */
 static void device_insertion_sort_klist(struct device *a, struct list_head *list,
 					int (*compare)(const struct device *a,
-							const struct device *b))
+						       const struct device *b))
 {
 	struct list_head *pos;
 	struct klist_node *n;
Ready to commit - First verify all diffs and make any necessary changes

Would you like to commit these changes <y>: n
file: <drivers/base/bus.c> description: <fix brace positions> types:<open_brace,braces,else_after_brace,while_after_brace>
CHECK: braces {} should be used on all arms of this statement
#131: FILE: drivers/base/bus.c:131:
+	if (bus_get(bus)) {
[...]
+	} else
[...]

total: 0 errors, 0 warnings, 1 checks, 1272 lines checked

NOTE: Used message types: BRACES ELSE_AFTER_BRACE OPEN_BRACE WHILE_AFTER_BRACE

drivers/base/bus.c has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.
file: <drivers/base/bus.c> description: <fix blank lines> types:<line_spacing>
CHECK: Please don't use multiple blank lines
#35: FILE: drivers/base/bus.c:35:
+
+

WARNING: Missing a blank line after declarations
#131: FILE: drivers/base/bus.c:131:
+	int error;
+	if (bus_get(bus)) {

WARNING: Missing a blank line after declarations
#820: FILE: drivers/base/bus.c:820:
+	struct kobject *k = kset_find_obj(bus_kset, name);
+	return k ? to_bus(k) : NULL;

total: 0 errors, 2 warnings, 1 checks, 1272 lines checked

NOTE: Used message types: LINE_SPACING

Wrote EXPERIMENTAL --fix correction(s) to 'drivers/base/bus.c'

Do _NOT_ trust the results written to this file.
Do _NOT_ submit these changes without inspecting them for correctness.

This EXPERIMENTAL file is simply a convenience to help rewrite patches.
No warranties, expressed or implied...

drivers/base/bus.c has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.
Compiling original version...
  CHK     include/config/kernel.release
make[1]: `all' is up to date.
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CC      drivers/base/bus.o
patching file drivers/base/bus.c
Compiling modified version...
  CHK     include/config/kernel.release
make[1]: `all' is up to date.
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CC      drivers/base/bus.o
Comparing objects...
No object differences found
running checkpatch on possible checkpatch fixes...
drivers/base/bus.c.diff has no obvious style problems and is ready for submission.
Verify checkpatch output and make any necessary changes
Edit 'drivers/base/bus.c' if appropriate
Press the 'enter' key to continue: diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 83e910a..3546d02 100644
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
Ready to commit - First verify all diffs and make any necessary changes

Would you like to commit these changes <y>:

