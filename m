Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3J0Pdy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 11:33:54 -0400
Received: from know-smtprelay-omc-11.server.virginmedia.net ([80.0.253.75]:38982
	"EHLO know-smtprelay-omc-11.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab3J0Pdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 11:33:45 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Oct 2013 11:33:41 EDT
X-Originating-IP: [81.99.114.138]
X-Spam: 0
X-Authority: v=2.0 cv=D70fsYtj c=1 sm=1 a=rTb9Q+mClrhkGV9Ah9iRIA==:17
 a=ilpIEWZ5m7wA:10 a=IkcTkHD0fZMA:10 a=xqWC_Br6kY4A:10 a=xq3W2uTSAAAA:8
 a=N1CowNylAAAA:8 a=OF69nQEFR_AA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8
 a=iP7vMvkZAAAA:8 a=Q-fNiiVtAAAA:8 a=dOLNmq4gAAAA:8 a=9KgniYzLAAAA:8
 a=JfrnYn6hAAAA:8 a=YgwN3AOMAAAA:8 a=h4_5QhNRAAAA:8 a=2pr1_LwHAAAA:8
 a=RqOAJGx8AAAA:8 a=chRdUDfvAAAA:8 a=4mo8Gh65AAAA:8 a=OAH4P4gnAAAA:8
 a=9qxNCY_qAAAA:8 a=mK_AVkanAAAA:8 a=mDV3o1hIAAAA:8 a=5KhG19HoHrixldTwwesA:9
 a=QEXdDO2ut3YA:10 a=Sf_gFPzhefAA:10 a=PxmVRoa77dUA:10 a=M2ZxJNRDz-EA:10
 a=wTsYZljDQnEA:10 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=RwkgMvZ-mGsA:10
 a=lcTMV_K9oDIA:10 a=se4ZzDB93oyHazAc:21 a=dOka0avgOn9zTeOx:21
 a=G8it56Fk9W2rnskc:21 a=rTb9Q+mClrhkGV9Ah9iRIA==:117
Message-ID: <1382891243.2598.10.camel@artifact>
Subject: [PATCH] staging: Merge Crystal HD driver with linuxtv.org
From: Steven Newbury <steve@snewbury.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Naren Sankar <nsankar@broadcom.com>, Jarod Wilson <jarod@wilsonet.com>,
        Scott Davilla <davilla@4pi.com>, Manu Abraham <abraham.manu@gmail.com>
Date: Sun, 27 Oct 2013 16:27:23 +0000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The in-kernel staging version and upstream diverged in Jan 2010,
whilst the in-kernel version has been kept up to date with kernel
changes, both have recieved some clean ups and bug fixes, upstream
has also added support for new cards, particularly BCM70015 which
is now a much more common device than the original BCM70012 and
is currently available for purchase.

In addition to the changes below, I've applied all the relevant
modifications applied to the in-kernel version to the new code
introduced from upstream, in particular the removal of typedefs and
unified header handling.

Quite a lot of the code churn relates to upstream commit
317dbd6dda65b4177627d6417b762c287cefa0e7 (crystalhd: nuke BCMLOG
macros, use std dev_foo ones), I considered stripping these changes
out and making them a separate patch but decided to stay as close as
possible to the state of the current linuxtv.org codebase.

Unfortunately, AFAIK, it's not possible to simply merge the upstream
git history since the upstream code isn't in a kernel tree structure,
and isn't even in a simple directory, but includes a script to
convert the external module into a staging tree driver which I used
to create a reference tree.  I had to then manually merge both
versions and fix code conflicts.

It does now successfully detect and initialise a BCM70015 bought
last week from Amazon.  It is currently untested on the original
BCM70012.

Signed-off-by: Steven Newbury <steve@snewbury.org.uk>

Changes from git://linuxtv.org/jarod/crystalhd.git since divergence:

commit 3cb6786e11460b4d14f8316f8bc572427880d2ee
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Nov 5 14:25:34 2012 -0500

    driver: make it build again on 3.6.x kernels

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit fdd2f19ac739a3db1fd7469ea19ceaefe0822e5a
Author: Dan Carpenter <error27@gmail.com>
Date:   Mon Mar 14 16:02:54 2011 -0400

    crystalhd: don't waste the last char of buffer

    pinfo->name is a 32 char buffer.  In the original code, the last char
    wasn't fully utilized.

    Signed-off-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 40c8f3867416459df1a43ca8ad91a23c3cb5e4c1
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Mar 14 15:29:39 2011 -0400

    driver: ignore ko.unsigned files

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit e6c92a8915ea0f5a90a6b365305dcbead7e1af2d
Author: Bastien Nocera <hadess@hadess.net>
Date:   Mon Mar 14 19:08:01 2011 +0000

    gst: Link to libgstvideo properly

    By checking for its availability, and letting pkg-config
    do its job.

commit dd4f01a0f9861425406c9ead7e326324d525d19a
Author: Bastien Nocera <hadess@hadess.net>
Date:   Mon Mar 14 19:05:41 2011 +0000

    gst: Fix GCC 4.6 errors

commit 7af07e508d15a71bb1089f51120104d417757a55
Author: Bastien Nocera <hadess@hadess.net>
Date:   Mon Mar 14 19:02:14 2011 +0000

    gst: Don't use nano versions

    Those are for GStreamer CVS to use -Werror

commit c2aa618b9d0a73fa9712d5b0fe541c71f8b9b095
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Mar 14 15:27:44 2011 -0400

    gst plugin build may fail w/o this include

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 2a16a74a957c3f45643a3e43380ba3f31c1301ba
Author: Jarod Wilson <jarod@redhat.com>
Date:   Fri Jan 21 16:29:29 2011 -0500

    gst: use gboolean instead of bool

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit abec0970b8f53995679900f5e6c0294776e58992
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Mon Dec 6 13:36:21 2010 -0800

    cleaned up source code. Fixed device ID check. Added debug output for filter

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 368ce4d4799dd27830fc83ebc7a0a24ebf2dd5ec
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Tue Nov 30 18:03:45 2010 -0800

    version bumps

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit e61ae5d4dbc4658c79f1cf5cc3ff21debfad028e
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Tue Nov 30 18:00:33 2010 -0800

    working version of S3/S5 support. fixed issue with lack of EOS detection by HW

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit cf2f76de247d3ead2bcb6af5823032e4a224f1f9
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Tue Nov 30 17:57:35 2010 -0800

    updated firmware with faster recovery from S3/S5

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 212bced7a1f90d0d0749502802dca7673533d87b
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Tue Nov 30 17:57:03 2010 -0800

    removed suspend and resume code from filter to make it app agnostic. added support for detecting EOS correctly on some streams

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 2f072e24d71cf3165d3860f7f60ad70a0154a196
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Tue Nov 30 17:54:10 2010 -0800

    working version of S3 and S5 resume. compile errors fixed

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 433f44c018c495ae4e0734e5b6973293efd124bc
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Tue Nov 23 08:11:57 2010 -0800

    fixed firmware bug when there is an EOS without any pictures being decoded. FW will hang without this fix.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 867de8338233f94defe4aa2844855e61e5ce44fa
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Tue Nov 23 08:11:17 2010 -0800

    Added support for suspend and hibernate and restoring HW state and recovering from S3/S4/S5

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 66e6c3e9326fda945edc84ec3f1b744da5309e2b
Author: Jarod Wilson <jarod@redhat.com>
Date:   Tue Nov 30 10:33:57 2010 -0500

    libs: fix build after de-typedef'ing of kernel bits

    Pointed out by Ivo Anjo.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit d9302e40375b5e3dc4e998be06825c984e4109db
Author: Aristeu Rozanski <arozansk@redhat.com>
Date:   Fri Nov 19 14:20:08 2010 -0500

    fix chd_dec_pci_probe() resource leaking

    Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>

commit 5f216b901c1fedfaef2ed46f37963f3edbeeaa8d
Author: Aristeu Rozanski <arozansk@redhat.com>
Date:   Fri Nov 19 14:16:35 2010 -0500

    implement noop_llseek when not available

    noop_llseek is only available on 2.6.35+ kernels

    Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>

commit a3a1ddf37ec5c23ab2e4bf273314ebf1db1138ce
Author: Aristeu Rozanski <arozansk@redhat.com>
Date:   Fri Nov 19 13:30:53 2010 -0500

    fix resource leak in chd_dec_pci_suspend

    Found by code inspection

    Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>

commit 2bf839d2dcafd547130a4b2b9e761c4c75b4574d
Author: Janne Grunau <j@jannau.net>
Date:   Fri Nov 19 14:55:42 2010 +0100

    fix whitespace issues

    Signed-off-by: Janne Grunau <j@jannau.net>

commit a4e50d7e4754d11931857652f7809c0a180ad9f5
Author: Janne Grunau <j@jannau.net>
Date:   Fri Nov 19 13:08:06 2010 +0100

    convert C99 style comment to C90
    Signed-off-by: Janne Grunau <j@jannau.net>

commit e16764481f1e74375f7cd207cc79fdd6e0e6e2a5
Author: Janne Grunau <j@jannau.net>
Date:   Thu Nov 18 22:56:39 2010 +0100

    use int instead of BOOL

    makes bc_dts_types.h include in bc_dts_defs.h unnecessary and spares
    linux kernel devs one ugly header

    Signed-off-by: Janne Grunau <j@jannau.net>

commit 9f30eb32e40bd8791ed2a2ea675562421a523f9b
Author: Janne Grunau <j@jannau.net>
Date:   Thu Nov 18 22:40:16 2010 +0100

    remove trailing whitespace

    Signed-off-by: Janne Grunau <j@jannau.net>

commit 6e3b99f5fb26b29c28b123a4cca6def219a0a70c
Author: Janne Grunau <j@jannau.net>
Date:   Thu Nov 18 22:22:12 2010 +0100

    update export-driver-for-staging.sh for bcm70015

    Signed-off-by: Janne Grunau <j@jannau.net>

commit e8e79cfa958b7f4317334e747445732a7359ccae
Author: Janne Grunau <j@jannau.net>
Date:   Thu Nov 18 19:07:53 2010 +0100

    use cpu_to_be32 instead custom bswap macro

    Signed-off-by: Janne Grunau <j@jannau.net>

commit b6e7e904e71eb2c985cfbbd71278a907777c05af
Author: Lars Lindley <lindley@coyote.org>
Date:   Thu Mar 11 00:21:20 2010 +0100

    Whitespace fixes for bcm_70012_regs.h from commit 641b63f9981a082eeefab3b395203a54dcd6e93b

    Staging: crystalhd: Whitespace fixes, indentation fixes and 3 changed #includes

    These patches fixes some whitspace and indentation warnings from
    checkpatch.pl

    Also these changed #includes:
    	bc_dts_glob_lnx.h:43: WARNING: Use #include <linux/param.h> instead of <asm/param.h>
    	rystalhd_lnx.h:45: WARNING: Use #include <linux/io.h> instead of <asm/io.h>
    	crystalhd_lnx.h:49: WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

    It all compiles fine, but I don't have the hardware to test with..

    Signed-off-by: Lars Lindley <lindley@coyote.org>
    Cc: Jarod Wilson <jarod@redhat.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
    Signed-off-by: Janne Grunau <j@jannau.net>

commit 53bced8dd3167457130d916902a8db62689ad244
Author: Janne Grunau <j@jannau.net>
Date:   Thu Nov 18 16:35:52 2010 +0100

    add combined bcm70015 register definitions header

    cat bchp_misc[123].h \
        bchp_scrub_ctrl.h \
        bchp_wrap_misc_intr2.h \
        bchp_armcr4_bridge.h \
        bchp_intr.h \
        bchp_pri_arb_control_regs.h \
        bchp_ddr23_ctl_regs_0.h \
        bchp_ddr23_phy_byte_lane_0.h \
        bchp_ddr23_phy_byte_lane_1.h \
        bchp_ddr23_phy_control_regs.h \
        bchp_clk.h \
        bchp_pcie_tl.h \
        bchp_sun_gisb_arb.h \
        bchp_misc_perst.h \
        bchp_sun_top_ctrl.h \
        bchp_gio.h \
        bchp_pri_client_regs.h \
      > ../../../../../../../../link/bcm_70015_regs.h

    and strip unused defines

    Signed-off-by: Janne Grunau <j@jannau.net>

commit aafda836d1c629d809411713ad4de7ec91edba46
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Sun Aug 15 18:52:59 2010 +0200

    llseek: automatically add .llseek fop

    All file_operations should get a .llseek operation so we can make
    nonseekable_open the default for future file operations without a
    .llseek pointer.

    The three cases that we can automatically detect are no_llseek, seq_lseek
    and default_llseek. For cases where we can we can automatically prove that
    the file offset is always ignored, we use noop_llseek, which maintains
    the current behavior of not returning an error from a seek.

    New drivers should normally not use noop_llseek but instead use no_llseek
    and call nonseekable_open at open time.  Existing drivers can be converted
    to do the same when the maintainer knows for certain that no user code
    relies on calling seek on the device file.

    The generated code is often incorrectly indented and right now contains
    comments that clarify for each added line why a specific variant was
    chosen. In the version that gets submitted upstream, the comments will
    be gone and I will manually fix the indentation, because there does not
    seem to be a way to do that using coccinelle.

    Some amount of new code is currently sitting in linux-next that should get
    the same modifications, which I will do at the end of the merge window.

    Many thanks to Julia Lawall for helping me learn to write a semantic
    patch that does all this.

    ===== begin semantic patch =====
    // This adds an llseek= method to all file operations,
    // as a preparation for making no_llseek the default.
    //
    // The rules are
    // - use no_llseek explicitly if we do nonseekable_open
    // - use seq_lseek for sequential files
    // - use default_llseek if we know we access f_pos
    // - use noop_llseek if we know we don't access f_pos,
    //   but we still want to allow users to call lseek
    //
    @ open1 exists @
    identifier nested_open;
    @@
    nested_open(...)
    {
    <+...
    nonseekable_open(...)
    ...+>
    }

    @ open exists@
    identifier open_f;
    identifier i, f;
    identifier open1.nested_open;
    @@
    int open_f(struct inode *i, struct file *f)
    {
    <+...
    (
    nonseekable_open(...)
    |
    nested_open(...)
    )
    ...+>
    }

    @ read disable optional_qualifier exists @
    identifier read_f;
    identifier f, p, s, off;
    type ssize_t, size_t, loff_t;
    expression E;
    identifier func;
    @@
    ssize_t read_f(struct file *f, char *p, size_t s, loff_t *off)
    {
    <+...
    (
       *off = E
    |
       *off += E
    |
       func(..., off, ...)
    |
       E = *off
    )
    ...+>
    }

    @ read_no_fpos disable optional_qualifier exists @
    identifier read_f;
    identifier f, p, s, off;
    type ssize_t, size_t, loff_t;
    @@
    ssize_t read_f(struct file *f, char *p, size_t s, loff_t *off)
    {
    ... when != off
    }

    @ write @
    identifier write_f;
    identifier f, p, s, off;
    type ssize_t, size_t, loff_t;
    expression E;
    identifier func;
    @@
    ssize_t write_f(struct file *f, const char *p, size_t s, loff_t *off)
    {
    <+...
    (
      *off = E
    |
      *off += E
    |
      func(..., off, ...)
    |
      E = *off
    )
    ...+>
    }

    @ write_no_fpos @
    identifier write_f;
    identifier f, p, s, off;
    type ssize_t, size_t, loff_t;
    @@
    ssize_t write_f(struct file *f, const char *p, size_t s, loff_t *off)
    {
    ... when != off
    }

    @ fops0 @
    identifier fops;
    @@
    struct file_operations fops = {
     ...
    };

    @ has_llseek depends on fops0 @
    identifier fops0.fops;
    identifier llseek_f;
    @@
    struct file_operations fops = {
    ...
     .llseek = llseek_f,
    ...
    };

    @ has_read depends on fops0 @
    identifier fops0.fops;
    identifier read_f;
    @@
    struct file_operations fops = {
    ...
     .read = read_f,
    ...
    };

    @ has_write depends on fops0 @
    identifier fops0.fops;
    identifier write_f;
    @@
    struct file_operations fops = {
    ...
     .write = write_f,
    ...
    };

    @ has_open depends on fops0 @
    identifier fops0.fops;
    identifier open_f;
    @@
    struct file_operations fops = {
    ...
     .open = open_f,
    ...
    };

    // use no_llseek if we call nonseekable_open
    ////////////////////////////////////////////
    @ nonseekable1 depends on !has_llseek && has_open @
    identifier fops0.fops;
    identifier nso ~= "nonseekable_open";
    @@
    struct file_operations fops = {
    ...  .open = nso, ...
    +.llseek = no_llseek, /* nonseekable */
    };

    @ nonseekable2 depends on !has_llseek @
    identifier fops0.fops;
    identifier open.open_f;
    @@
    struct file_operations fops = {
    ...  .open = open_f, ...
    +.llseek = no_llseek, /* open uses nonseekable */
    };

    // use seq_lseek for sequential files
    /////////////////////////////////////
    @ seq depends on !has_llseek @
    identifier fops0.fops;
    identifier sr ~= "seq_read";
    @@
    struct file_operations fops = {
    ...  .read = sr, ...
    +.llseek = seq_lseek, /* we have seq_read */
    };

    // use default_llseek if there is a readdir
    ///////////////////////////////////////////
    @ fops1 depends on !has_llseek && !nonseekable1 && !nonseekable2 && !seq @
    identifier fops0.fops;
    identifier readdir_e;
    @@
    // any other fop is used that changes pos
    struct file_operations fops = {
    ... .readdir = readdir_e, ...
    +.llseek = default_llseek, /* readdir is present */
    };

    // use default_llseek if at least one of read/write touches f_pos
    /////////////////////////////////////////////////////////////////
    @ fops2 depends on !fops1 && !has_llseek && !nonseekable1 && !nonseekable2 && !seq @
    identifier fops0.fops;
    identifier read.read_f;
    @@
    // read fops use offset
    struct file_operations fops = {
    ... .read = read_f, ...
    +.llseek = default_llseek, /* read accesses f_pos */
    };

    @ fops3 depends on !fops1 && !fops2 && !has_llseek && !nonseekable1 && !nonseekable2 && !seq @
    identifier fops0.fops;
    identifier write.write_f;
    @@
    // write fops use offset
    struct file_operations fops = {
    ... .write = write_f, ...
    +	.llseek = default_llseek, /* write accesses f_pos */
    };

    // Use noop_llseek if neither read nor write accesses f_pos
    ///////////////////////////////////////////////////////////

    @ fops4 depends on !fops1 && !fops2 && !fops3 && !has_llseek && !nonseekable1 && !nonseekable2 && !seq @
    identifier fops0.fops;
    identifier read_no_fpos.read_f;
    identifier write_no_fpos.write_f;
    @@
    // write fops use offset
    struct file_operations fops = {
    ...
     .write = write_f,
     .read = read_f,
    ...
    +.llseek = noop_llseek, /* read and write both use no f_pos */
    };

    @ depends on has_write && !has_read && !fops1 && !fops2 && !has_llseek && !nonseekable1 && !nonseekable2 && !seq @
    identifier fops0.fops;
    identifier write_no_fpos.write_f;
    @@
    struct file_operations fops = {
    ... .write = write_f, ...
    +.llseek = noop_llseek, /* write uses no f_pos */
    };

    @ depends on has_read && !has_write && !fops1 && !fops2 && !has_llseek && !nonseekable1 && !nonseekable2 && !seq @
    identifier fops0.fops;
    identifier read_no_fpos.read_f;
    @@
    struct file_operations fops = {
    ... .read = read_f, ...
    +.llseek = noop_llseek, /* read uses no f_pos */
    };

    @ depends on !has_read && !has_write && !fops1 && !fops2 && !has_llseek && !nonseekable1 && !nonseekable2 && !seq @
    identifier fops0.fops;
    @@
    struct file_operations fops = {
    ...
    +.llseek = noop_llseek, /* no read or write fn */
    };
    ===== End semantic patch =====

    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Cc: Julia Lawall <julia@diku.dk>
    Cc: Christoph Hellwig <hch@infradead.org>

commit d4a63aa414b5b57ad40b6060cbfc48effdbe7c36
Author: Scott Kidder <scott.kidder11@gmail.com>
Date:   Wed May 26 23:38:45 2010 -0500

    Staging: crystalhd: removed kfree(NULL) checks

    Removed kfree(NULL checks) that were not necessary

    Signed-off-by: Scott Kidder <scott.kidder11@gmail.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

commit 6943691302f35418d2ac0d0536f4669a9e924aa1
Author: Janne Grunau <j@jannau.net>
Date:   Tue Nov 16 21:11:30 2010 +0100

    remove typedefs in crystalhd_cmds.h

    Signed-off-by: Janne Grunau <j@jannau.net>

commit 3cd3da74f092251212d99ab3bf0460f8c25994ec
Author: Janne Grunau <j@jannau.net>
Date:   Tue Nov 16 21:09:05 2010 +0100

    remove typedefs in crystalhd_flea_ddr.h

    Signed-off-by: Janne Grunau <j@jannau.net>

commit a20cd29aadccc5bdb0c5a197cb22450d630f1541
Author: Janne Grunau <j@jannau.net>
Date:   Tue Nov 16 18:37:48 2010 +0100

    remove typedefs from driver/linux/crystalhd_fw_if.h

    Signed-off-by: Janne Grunau <j@jannau.net>

commit 7a8a64a830009214535ba0836d3d7e6664f48bee
Author: Janne Grunau <j@jannau.net>
Date:   Tue Nov 16 18:29:32 2010 +0100

    remove typedefs from crystalhd_hw.h

    Signed-off-by: Janne Grunau <j@jannau.net>

commit e6658122e2957ec4211de34ea356bcee41b9ee5e
Author: Janne Grunau <j@jannau.net>
Date:   Tue Nov 16 18:14:11 2010 +0100

    remove typedefs from crystalhd_lnx.h

    Signed-off-by: Janne Grunau <j@jannau.net>

commit 725db77a9e9c3c26e2d7212435423d0678633778
Author: Janne Grunau <j@jannau.net>
Date:   Tue Nov 16 18:10:53 2010 +0100

    remove typedefs from crystalhd_misc.h

    Signed-off-by: Janne Grunau <j@jannau.net>

commit fba421669f0dc66d2b9e0b1e0751454fee735e80
Author: Janne Grunau <j@jannau.net>
Date:   Tue Nov 16 18:04:05 2010 +0100

    remove typedefs in FleaDefs.h

    Signed-off-by: Janne Grunau <j@jannau.net>

commit a870d2ffbdb8f1843dcfe64925a9d340cc8da7f8
Author: Julia Lawall <julia@diku.dk>
Date:   Tue May 11 20:26:57 2010 +0200

    Staging: Drop memory allocation cast

    Drop cast on the result of kmalloc and similar functions.

    The semantic patch that makes this change is as follows:
    (http://coccinelle.lip6.fr/)

    // <smpl>
    @@
    type T;
    @@

    - (T *)
      (\(kmalloc\|kzalloc\|kcalloc\|kmem_cache_alloc\|kmem_cache_zalloc\|
       kmem_cache_alloc_node\|kmalloc_node\|kzalloc_node\)(...))
    // </smpl>

    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

commit 54ec53ebc3b65ef5666e89c1cd7275e25b0ff84a
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Nov 4 15:43:22 2010 -0400

    gitignore generated files

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 2f2f5f8057635ef71b5f9bcbc52a96c8d90f7d8f
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Nov 4 15:39:54 2010 -0400

    gst: remove generated files from source control

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 831a1c92df5148cd046410abd90b9c1878e607db
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Wed Nov 3 15:02:01 2010 -0700

    Changed close of the HW to be IOCTL based to avoid problems with dup and forks. Handles are not correctly released on player exits - for example with vlc

commit 87ad630be14d46cad538b5b3109f35d91fc1f8b8
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Wed Oct 20 17:34:52 2010 -0700

    updated version numbers

commit b23a837f8b3002c14246918ce7b865eef85cdcae
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Wed Oct 20 17:15:27 2010 -0700

    changing user/kernel define includes to allow third-party configure scripts to work correctly

commit 72d916dabea9efff1631ef1d3ace42b02647c9d0
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Wed Oct 20 17:13:19 2010 -0700

    enable 70015 power management by default

commit 3fb2710ad06e1bdc3930d9fd1c7a3c59a8eb245e
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Fri Oct 8 12:17:16 2010 -0700

    Improve support for Suspend/Hibernate

commit 52758418ae6d6a7a4feae528be6b402708c3620e
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Fri Oct 8 11:59:07 2010 -0700

    Updated GST version

commit 2bcdb02e93edeb5322e3c8ae171f79acdccb0b4a
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Fri Oct 8 11:58:07 2010 -0700

    Fixed issue with failure to playback MPEG-2 streams with no codec_data structure

commit f0a74bbf038c55f6b8f1b7c74577040d0011e377
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Nov 4 14:59:24 2010 -0400

    driver: add ioctl support for kernel 2.6.36+

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit a3a83b8cee454bafd83ccaaa5e35029d6c409c9d
Author: Scott Davilla <davilla@4pi.com>
Date:   Tue Sep 28 15:10:05 2010 -0400

    lib: fix DtsFlushInput segfault

    PESConvParams buffer ownership is wacky. DtsReleasePESConverter is
    called when device is closed, DtsSetPESConverter (and
    DtsInitPESConverter ) in DtsSetInputFormat before DtsOpenDecoder.

    But you call DtsFlushInput(m_device, 2), "Flushes all the decoder
    buffers, input, decoded and to be decoded."

    then decoder is closed/opened and the close nukes PESConvParams buffers
    and the next time one feeds DtsProcInput, you segfault.

    You could keep a copy of what is passed into DtsSetInputFormat and reset
    on internal/open close of decoder but it's easier to just not touch
    PESConvParams buffers, they will get deleted when device is closed or
    resized as needed.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 6b3a205d6edce8c45f47daec09e372ecbf20f6de
Author: Scott Davilla <davilla@4pi.com>
Date:   Tue Sep 28 15:09:02 2010 -0400

    lib: free tx thread first

    X Thread makes device calls and uses shared mem, exit TX Thread first,
    then close up device. This fixes segfaults on playback stop and device
    close.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 191068804f18cb30c908a52998e06db077145b63
Author: Scott Davilla <davilla@4pi.com>
Date:   Tue Sep 28 15:08:02 2010 -0400

    lib: user abort is not a failure

    BC_STS_IO_USER_ABORT returned from BCM_IOC_PROC_INPUT is not a failure
    so don't log it as such.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 9c530d228f2fbbe46afd1248af01e553ab5bf50b
Merge: 0e26588 1d88ad2
Author: Jarod Wilson <jarod@redhat.com>
Date:   Tue Sep 28 15:06:23 2010 -0400

    Merge branch 'master' of git+ssh://git.wilsonet.com/srv/git/crystalhd

commit 0e265885bdf735a31e867f25c5a745739ba36214
Author: Vasiliy Kulikov <segooon@gmail.com>
Date:   Tue Sep 28 14:59:47 2010 -0400

    crystalhd: fix signed bug

    chd_dec_major is unsigned, so check chd_dec_major < 0 doesn't make
    sense. Since it is used as signed, declare it as int.

    Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 1d88ad2633fa91d3cad7b09d92f6f42b3e270ec6
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Thu Sep 23 21:26:33 2010 -0400

    Updated version numbers

    - A certain libcrystalhd user expects to see minor >= 20 reported to
      enable high-performance StageVideo mode. We only report this inside
      the driver, the so's version remains 3.6.0 right now...

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 2e7535e9504254854765f97fe74b23d0ecd40d4b
Author: Taylor Ralph <taylor.ralph@gmail.com>
Date:   Thu Sep 23 15:50:19 2010 -0400

    [lib] add function to get tx buf free size

    Jarod changed things from int32_t to unint32_t to match freeSize's
    type, and added function pseudo-documentation block. And any bugs.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 6345d8a74cd3b0a743489a59afae8c27363012e2
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Sep 23 15:39:08 2010 -0400

    [driver] be a wee bit less verbose unless debug mode enabled

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 7c6639339803e0375884da244f9a339398048001
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Sep 23 15:06:41 2010 -0400

    [driver] bump minor version rev to match lib

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 5ca69a4831578ee385a93c58b5f0a6a7e148cfb5
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Wed Sep 22 12:07:21 2010 -0700

    libcrystalhd: fix usage documentation error

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit a82496e6aefb111b7570b3c9120659b2c5f74c7f
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Wed Sep 22 12:03:09 2010 -0700

    clean up gstreamer state management code

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 7692b0d4b61120a0d3774214255ad83a26c8f7da
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Wed Sep 22 23:31:40 2010 -0400

    Moved multi-process variables to global shared memory. Allow only single      application to open handle to HW.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 3383a1187fd5ce8e2596ab5a1ba8ae2b9b44ae45
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Wed Sep 22 11:32:09 2010 -0700

    driver: fix multiple possible hangs

    - Fixed issue with hard hang on multiple opens.
    - Fixed issue of stalling for 3 seconds on close under certain conditions.
    - Fixed issue of Firmware commands not completing correctly to close the decoder safely on Signals.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 84760fd6ec9c6b87d4437bcb598471a512a10b90
Author: Kulikov Vasiliy <segooon@gmail.com>
Date:   Mon Aug 23 14:01:53 2010 -0400

    crystalhd: call disable_pci_device if pci_probe failed

    Driver should call disable_pci_device() if it returns from pci_probe()
    with error.

    Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 32491de9d8d9aba18ffeb64d94f2d3322ed19577
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Aug 23 13:55:56 2010 -0400

    lib: flea doesn't support setting core clock at all

    Pointed out by Scott Davilla. Just a micro-optimization then to not call
    DtsSetCoreClock on flea now. Leaving it in there #if 0'd out w/a
    comment, just in case support for setting the clock on flea does show up
    at some point in the future...

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit c20a5d41cc9f198a88ec81fe57570df5a97db59d
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Aug 23 13:10:05 2010 -0400

    lib: set core clock to 180 on link cards

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 465bb3d3eecf1741c7709478c3fe9b56fe033271
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Aug 23 13:09:23 2010 -0400

    lib: streamline DtsDevRegisterWr a bit

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit a3a8e9c5a2b52d8867425d0c899fda7fc7f6f80e
Author: Scott Davilla <davilla@4pi.com>
Date:   Mon Aug 23 11:28:24 2010 -0400

    crystalhd: check fetch before add

    Make sure we were successful fetching before we add to queue

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit e1196a1dd28324d1debc5a1f868325190fd809dc
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Aug 23 11:27:07 2010 -0400

    crystalhd: change license on flea reg defs

    from Scott Davilla, approved by Naren Sankar at Broadcom.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 5b951470bcd15d4e07466d3d0b423e703ea9dd79
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Wed Aug 18 10:08:56 2010 -0700

    Fixed 32-bit compile for sse2

commit 014e9fe03a38c92a1bdfcdb322f9356abdcf929f
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Aug 23 11:12:49 2010 -0400

    lib: make sure var is initialized

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit ca04e12da96ed3b453032fd586ef368ad69b4f24
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Mon Aug 16 13:24:44 2010 -0700

    expanded the fetch semaphone to cover the entire fetch operation to prevent clashing with the next frame peeking

commit 1348474a5d34ec685bbfec2e1ed117e554998e1c
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Mon Aug 16 13:24:14 2010 -0700

    removed extra debug print

commit 72907973f7a29316d6fce1576937588cc329d53d
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Mon Aug 16 10:55:57 2010 -0700

    Added support for on the fly copying of 422 to 420 including support for NV12. Code originally from bambry@adobe.com

commit 60460ebc21209b8b6bd105fe68aca38145187eeb
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Mon Aug 16 10:54:58 2010 -0700

    Correctly fixed issue of disabling HW scaling by default

commit c749a814f597c0bb1ca40e5c926f1e8e1d486051
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Mon Aug 16 10:54:07 2010 -0700

    Fixed return status checking for memory allocations

commit 2444c6ebd1fc17689963a4deba2ab22d7218c4e4
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Thu Aug 12 10:49:56 2010 -0700

    Updated library version number correctly

commit 3db6748162c14dee44c4b560e5b96e3ee7fcaab3
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Thu Aug 12 10:43:58 2010 -0700

    Fixed incorrect enabling of scaling from GST

commit 6df10a0599b5adf7e6f08529f0954a3fa24ad0ad
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Wed Jul 28 09:38:20 2010 -0700

    added support to peek next picture number and flags. Fixed issue with reading incorrect register for DMA list 1

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 1f091ef3c9b1ca4e7dda0b0d729d4232a77b0793
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Wed Jul 28 09:37:03 2010 -0700

    added interlaced playback support for gstreamer

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit adbc32f24506cc328a124e53044068d21e425edd
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Wed Jul 28 09:35:43 2010 -0700

    added support in library to peek the next picture picture number and top and bottom flags for field video

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit c8f00de0d7573d76bf5e8a880ad50f43485faf4c
Author: Jarod Wilson <jarod@redhat.com>
Date:   Fri Jul 23 23:22:03 2010 -0400

    crystalhd: make some logging less verbose, use dev_foo macros

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit ce6fe949cc76875dff6c5777be6bfee55a1387bc
Author: Edgar (gimli) Hucek <gimli@dark-green.com>
Date:   Fri Jul 23 22:06:51 2010 -0400

    libcrystalhd: fix some compiler warnings

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 226132bbb412d6a75bd8c9e5f398238065fa32d1
Author: Scott Davilla <davilla@4pi.com>
Date:   Fri Jul 23 22:04:59 2010 -0400

    crystalhd: fix driver compile on older kernels

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit e1244343b81ec077b8c5e339c839e2f22e56a41c
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Fri Jul 23 18:17:38 2010 -0700

    Added support for detecting VC1 v/s WMV9. Cleaned up unused WMV code. Added support for detecting DIVX types

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 5214f2a047c9ea33c26c417add7e5b61670b4e67
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Fri Jul 23 18:12:35 2010 -0700

    fixed the parser to take into account that there is no extra data when data type is Annex B compatible

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit bcc1d54915cbb400ce8825c0cf698934f05e3605
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Fri Jul 23 18:11:32 2010 -0700

    updated library version to match code merged from Windows

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit a61f1529b80fc6172561284b29d3261dc15b16b8
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Fri Jul 23 18:10:53 2010 -0700

    added some error checking code to prevent kernel oops

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 84306614fe62eae5f58c382a12f0a1cc6a25c664
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Tue Jul 20 17:35:17 2010 -0700

    added Firmware binary license text

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 24f6d7afd6d2a37be147fdb716621d64734c5248
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Tue Jul 20 16:59:42 2010 -0700

    added support to detect the HW type and features ahead of actuallying starting the decoder. Use this feature to advertize different capabilities in the GST plug-in to support MPEG4 decoder

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit f4956d455e6676a655f181b025d61360c4ac13ac
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Tue Jul 20 16:56:55 2010 -0700

    Driver updates to cleanly ask for MSI. Updated version numbers

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit ec49b91ff32e87e677ba7df82a5fb71ea0ee11b2
Author: Edgar (gimli) Hucek <gimli@dark-green.com>
Date:   Fri Jul 16 15:27:15 2010 -0400

    libcrystalhd: add internal mdata garbage collector routine

    - misc formatting cleanups by Jarod

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 8ced5eaa5db7d880a1f2b4d86f38a2d38920bbad
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Jul 15 23:34:14 2010 -0400

    fix up build after flea reg debug spew removal

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit aa8dce7a83fcece31e103b8fb60f1a53b0d50797
Author: Scott Davilla <davilla@4pi.com>
Date:   Thu Jul 15 23:20:56 2010 -0400

    add missing spinlock unlocks

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 4884553c681fe03d73ecbd1b3def46c909df28ac
Author: Scott Davilla <davilla@4pi.com>
Date:   Thu Jul 15 23:15:49 2010 -0400

    casting fixes

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 9c27acf43b15530cc13a05d9140aa0a1b63a311b
Author: Scott Davilla <davilla@4pi.com>
Date:   Thu Jul 15 23:15:12 2010 -0400

    remove register debug spew in flea

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit bbba09d111d173fdb6854b3319a9e5c5ca1eeeda
Author: Scott Davilla <davilla@4pi.com>
Date:   Thu Jul 15 23:14:26 2010 -0400

    fix missing newlines

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 222eaed6e68748240f89d5404d1a095a21c3077e
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Wed Jul 14 13:07:45 2010 -0700

    Update to new format change logic. Clean up firmware

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit bb811baa136ab6b933ebb2eaec8bd420cfc72671
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Tue Jul 13 13:29:51 2010 -0700

    making gst plugin build against system libcrystalhd

    Use installed library headers rather than local dev one.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 66a7e46464edd6a9d1a2616be56f36366caa234f
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Tue Jul 13 12:35:38 2010 -0700

    cleaned up some includes to make building deb packages easier

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 24608d2524d4db2933858651f3d6362db8db2487
Author: Jarod Wilson <jarod@redhat.com>
Date:   Tue Jul 13 22:20:25 2010 -0400

    crystalhd: remove no longer used chd_set_log_level prototype

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 9de6c2956c8ffb5f9f25d704c793cce3759546c7
Author: Jarod Wilson <jarod@redhat.com>
Date:   Tue Jul 13 22:19:32 2010 -0400

    crystalhd: remove noisy register debugging

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit c6a10e176aade2ba2c5eae7aa14d3a31da6ac9a0
Author: Jarod Wilson <jarod@redhat.com>
Date:   Tue Jul 13 22:12:37 2010 -0400

    libcrystalhd: fix license in fwcmds sources

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 42bd352f7af6b547839f8b8c7c741bce14602096
Author: Jarod Wilson <jarod@redhat.com>
Date:   Tue Jul 13 22:12:02 2010 -0400

    gst: gitignore stamp-h1

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 2c35546c0d82814986dcced8ccf7f44c3d8cedb0
Author: Jarod Wilson <jarod@redhat.com>
Date:   Tue Jul 13 18:19:18 2010 -0400

    crystalhd: uv_start needs to be unsigned long

    Pointed out by Scott Davilla, confirmed by Naren Sankar. I just commit
    stuff... :)

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit a8839d50a4117344f621792eebaa9e8b287936fa
Merge: 353cbb9 6ddb496
Author: Jarod Wilson <jarod@redhat.com>
Date:   Tue Jul 13 14:46:41 2010 -0400

    Merge branch 'master' of git+ssh://devel.wilsonet.com/srv/git/crystalhd

commit 353cbb90c6798fdb9baa0d7deb16ca4c30b417e7
Author: Edgar (gimli) Hucek <gimli@dark-green.com>
Date:   Tue Jul 13 14:46:25 2010 -0400

    libcrystalhd: be more gentle on scaling params

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 6ddb4963330d1353676b31c001558d8139c03319
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Jul 12 19:54:11 2010 -0400

    gst: remove one more file that shouldn't be in git

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit abfa30f6281153f47f29a392fc4520d29390aa9e
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Jul 12 19:51:53 2010 -0400

    gst: make it build

    ...and remove a bunch of junk that shouldn't be under version control.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit c3bd2e77980ee26ca3bfbf708c773d604c1c6a39
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Jul 12 19:48:19 2010 -0400

    examples: add gitignoreage

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit e1f28f47822bbd16418ab1493b45733a2bb14841
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Jul 12 19:47:22 2010 -0400

    examples: make them build again

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit e54380692ae2c124c1dff2fc82354dd73695a719
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Jul 12 15:33:36 2010 -0400

    libcrystalhd: don't need POINTER_32 on Linux

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 5ce12f14f66cef2639a4319f226cfb4c74d31209
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Jul 12 15:32:44 2010 -0400

    crystalhd: add missing headers needed to compile driver

    Pointed out by gimli.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit ba77ae3fc62f85d616aaea776ee3ef02b0aeefc3
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Mon Jul 12 14:59:59 2010 -0400

    crystalhd: add locking around hw accesses

    Fixed issue of holding HW lock and sleeping in kernel when probing for
    picture  numbers. Fixed parsing of the Mode field so we can release DMA
    buffers correctly. Correctly working with Adobe FP for both 70012    and
    70015. Elimiated HW pause for 70012 since it is borked. Added SW pause
    from apps side. Currently only for FP and GST. Need to
    fix for other apps.

    Signed-off-by: Narendra Sankar <nsankar@broadcom.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit bf3ab5fe081b1df220b35744d605ae38140c61ee
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Jul 12 14:42:18 2010 -0400

    firmware: new bcm70012 firmware image

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit a6ee265bcbf16d2e37843e9b07d250a669a2dab2
Merge: d9091fb 93b2fba
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Jul 12 14:36:46 2010 -0400

    Merge branch 'master' of git+ssh://git.wilsonet.com/srv/git/crystalhd

commit 93b2fba7e7aff1e9108db1f55157b7a89bef1ce9
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Jul 12 00:43:29 2010 -0400

    lib: typo compile fix

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 0449ab3da0ca7eee94080ffb6dc68aa5d2c9a9f7
Author: Scott Davilla <davilla@4pi.com>
Date:   Sun Jul 11 19:36:27 2010 -0400

    libcrystalhd: pendMdata fixes for bcm70012

    need to look further back than 10

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 9f55201c38bc5c3c0e20966935bcfe853fe0fa8d
Author: Edgar (gimli) Hucek <gimli@dark-green.com>
Date:   Sun Jul 11 19:27:08 2010 -0400

    libcrystalhd: enable scaling on bcm70015 crystalhd

    Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 51d73bf0623cc1bbde257cfd4408a910ca24c5da
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Sun Jul 11 19:10:46 2010 -0400

    crystalhd: merge to latest windows code

    - pretty much in sync with current windows driver
    - return of 64-bit functionality
    - hardware scaling enabled
    - preliminary multiple application support

    Signed-off-by: Narendra Sankar <nsankar@broadcom.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 5088d0051646a5bf78684caeeaee98325a3dbb9c
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Sun Jul 11 18:53:32 2010 -0400

    libcrystalhd: mark cancel tx function as success always

    Signed-off-by: Narendra Sankar <nsankar@broadcom.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 48c04c40e882de8f7dd75921024bbfe9bb053994
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Sun Jul 11 18:52:12 2010 -0400

    gst: session number is no longer used to detect repeated pictures

    Signed-off-by: Narendra Sankar <nsankar@broadcom.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 534fb998bc7c8784fa72eaf1ddfb1de99fa84793
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Sun Jul 11 18:50:49 2010 -0400

    crystalhd: added 70015 device id for older kernels

    Signed-off-by: Narendra Sankar <nsankar@broadcom.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit e8d1fb6f321cee63c07e24dfe026279fe8cb140c
Author: Jarod Wilson <jarod@redhat.com>
Date:   Sun Jul 11 18:36:37 2010 -0400

    update comments to match libcrystalhd_version.h name change

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 5f5029dc3687aa50cf7186b2f8488f6e2a11d60f
Author: Jarod Wilson <jarod@redhat.com>
Date:   Sun Jul 11 18:34:48 2010 -0400

    Resync with Scott's crystalhd for osx tree, up to revision 126

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit f583f1ff86d21c58c4dd7c4efb7b227f3f1e835d
Author: Jarod Wilson <jarod@redhat.com>
Date:   Tue Jun 29 10:42:49 2010 -0400

    crystalhd_lnx: remove casts from void*

    Remove unnesessary casts from void*.

    Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 4c6a4bfd64edb73097af51995ef0939a16cc37ef
Author: Jarod Wilson <jarod@redhat.com>
Date:   Tue Jun 29 10:38:25 2010 -0400

    lib: rename version_lnx.h to libcrystalhd_version.h and install it

    Install the library version header, so that programs compiling
    against libcrystalhd can use conditionals according to the lib
    version.

    Based on initial patch from gimli and discussion w/Scott and Naren.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 986a1bdb2ac2584bfafad2af74002dcf0591d8d2
Author: Scott Davilla <davilla@4pi.com>
Date:   Mon Jun 21 23:03:22 2010 -0400

    re-re-fix uint16_t to int16_t

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit aeb7b43db6106e302750764d3d1c64375234ce5a
Author: Scott Davilla <davilla@4pi.com>
Date:   Mon Jun 21 23:02:40 2010 -0400

    keep rxcap buffers when doing suspend

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit a3155bd73023e16cc24393115406f5aa46268d0d
Author: Scott Davilla <davilla@4pi.com>
Date:   Mon Jun 21 23:01:52 2010 -0400

    clean up mpeg2test code

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 7575f0935e9f3a68649d2585c7fa52919d171cc5
Author: Scott Davilla <davilla@4pi.com>
Date:   Mon Jun 21 23:01:02 2010 -0400

    system headers need to come first

    required for mac os x

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit f660a4bb1e960c3897fb80dd048cfb15807753e7
Author: Scott Davilla <davilla@4pi.com>
Date:   Mon Jun 21 23:00:18 2010 -0400

    remove duplicated function call

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 6c513c1d9a8adcfcf06a17a3d37268e26655ce1d
Author: Scott Davilla <davilla@4pi.com>
Date:   Mon Jun 21 22:59:18 2010 -0400

    pass real struct instead of void in crystalhd_dioq_fetch_wait

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 781fc75b899fd09d536fedc1de986f922eff3bb0
Author: Scott Davilla <davilla@4pi.com>
Date:   Mon Jun 21 22:58:37 2010 -0400

    remove unused chd_set_log_level

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 5488fc2bdd653e1f2d1c62f1beecb9b833b23e23
Author: Jarod Wilson <jarod@redhat.com>
Date:   Sun Jun 20 12:51:50 2010 -0400

    fix some whitespace damage and silence noisy printk

    printk noise pointed out by gimli.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 483319eda67d4a2ea8e8645e55cb8bc6603f50ed
Author: Edgar (gimli) Hucek <gimli@dark-green.com>
Date:   Sun Jun 20 12:50:03 2010 -0400

    compile fix

    Signed-off-by: Edgar (gimli) Hucek <gimli@dark-green.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit c1489b3178dae679ece87e52dd324cfb274da747
Author: Edgar (gimli) Hucek <gimli@dark-green.com>
Date:   Sun Jun 20 12:48:57 2010 -0400

    lib: vc1 correctness fix

commit 2330bc975ca2987632f145c29be8719e2311bcf5
Author: Jarod Wilson <jarod@redhat.com>
Date:   Sun Jun 20 12:45:22 2010 -0400

    64-bit lib compile fix

    Pointed out by gimli.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 4b3ead2410b17554fb9885abff0747d8b345ca93
Author: Jarod Wilson <jarod@redhat.com>
Date:   Sun Jun 20 00:55:54 2010 -0400

    drop a line of dead code

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit c967adc94ffa1281506b59101fa4c88ef9c7be64
Author: Jarod Wilson <jarod@redhat.com>
Date:   Sun Jun 20 00:51:05 2010 -0400

    driver: make it compile again

    I missed a few things merging hunks of Naren's patches that didn't
    apply cleanly, and a few other minor things needed fixing so we
    can compile on both 32-bit and 64-bit. At least, it compiles on a
    64-bit host now...

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit ebdd07cd259c83a01c7b539d1340449f503644ae
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Sat Jun 19 23:53:20 2010 -0400

    some formatting fixups

    Signed-off-by: Narendra Sankar <nsankar@broadcom.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 1a35a4f98804a1a6a0547dacd3b4560f3ce186d7
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Sat Jun 19 23:43:57 2010 -0400

    added support for peeking timestamps, separate TX thread to optimize performance

    Signed-off-by: Narendra Sankar <nsankar@broadcom.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 328958bbb425ee5406d36d51e72da1c0ad103a2b
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Sat Jun 19 23:40:56 2010 -0400

    First working version of driver for 70015

    Signed-off-by: Narendra Sankar <nsankar@broadcom.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 24795a78e364f8a6ad877fb40257b7dd149ed97d
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Sat Jun 19 23:35:09 2010 -0400

    Initial support for BCM70015 including FW download, TX DMA, RX DMA, picture interrupt

    Signed-off-by: Narendra Sankar <nsankar@broadcom.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit d9091fbdf742de635bda977f6060a4de56d16b40
Author: Charles Clément <caratorn@gmail.com>
Date:   Tue Jun 8 10:55:20 2010 -0400

    crystalhd: remove unused #include <linux/version.h>

    Signed-off-by: Charles Clément <caratorn@gmail.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit f1f6818cb170ad5ce693e3629875d3f1b2558765
Author: Jarod Wilson <jarod@redhat.com>
Date:   Tue Jun 8 10:53:08 2010 -0400

    crystalhd: cleanup all WIN references

    Signed-off-by: Charles Clément <caratorn@gmail.com>

    Additional cleanups in the same area by Jarod.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit c6ca98d433808f9fb3681b3eada25fcd5f1d55c9
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Jun 7 14:44:03 2010 -0400

    driver: minimize chd_get_device usage (and rename to chddev)

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit fdf75ed369b4a9c3a5b8c598248c5bf6e4204047
Author: Scott Davilla <davilla@4pi.com>
Date:   Sun Jun 6 16:39:44 2010 -0400

    tsnum in DtsFetchMdata can't go < 0 if it's uint16_t, make it int16_t

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 7e5f0bcd9a455a5ef86d191b8b39bf708f773f40
Author: Scott Davilla <davilla@4pi.com>
Date:   Sun Jun 6 16:37:17 2010 -0400

    fix build for linux kernel versions 2.6.24 and earlier

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit eb056668a90ffab973ea35734a85349b9a507337
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Sun Jun 6 14:16:23 2010 -0400

    Update bcm70015 register include path

    Signed-off-by: Narendra Sankar <nsankar@broadcom.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 5e2a07485fd4939d6748dd5fddc87b412bf6bb53
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Sun Jun 6 14:15:30 2010 -0400

    Add bcm70015 register interface specifications

    Signed-off-by: Narendra Sankar <nsankar@broadcom.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 19cb8e2b21c311dba96766c69fe1dba5869b6e3a
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Sun Jun 6 14:04:32 2010 -0400

    Set up function pointers and split out 70012/15 support code

    Signed-off-by: Narendra Sankar <nsankar@broadcom.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 4f5f6f087630e257cbcdae597befcf3ab834f3f5
Author: Narendra Sankar <nsankar@broadcom.com>
Date:   Sun Jun 6 13:49:10 2010 -0400

    initial cleanup to facilitate bcm70015 support

    Lots of clean-ups and code reorg to facilitate forthcoming bcm70015
    support. Also moves a good chunk of code that was in the gstreamer
    layer to the driver interface library layer.

    Signed-off-by: Narendra Sankar <nsankar@broadcom.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit fd9c282d1257a833cea4acd94a65505a8b5f1b90
Author: Scott Kidder <scott.kidder11@gmail.com>
Date:   Fri Jun 4 16:35:04 2010 -0400

    crystalhd: removed kfree(NULL) checks

    Removed kfree(NULL checks) that were not necessary

    Signed-off-by: Scott Kidder <scott.kidder11@gmail.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 01531d1559738abe51bf5c38a392472b7c6bac7a
Author: Leon Woestenberg <leon.woestenberg@gmail.com>
Date:   Fri Jun 4 16:31:29 2010 -0400

    crystalhd: Fix for big-endian systems

    The original CrystalHD driver assumes a little endian bitfield host.

    This patch adds support for big-endian bitfield hosts.

    It was tested by verifying the values of all hardware register accesses
    on a big-endian host were equal to a little-endian host.

    The use of bitfields is discouraged for hardware access, so this needs
    to be rewritten to use macro definitions at some point.

    Signed-off-by: Leon Woestenberg <leon@sidebranch.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 1f293c968e5ab8dad3ad0c3ceefa91cbb1bcce63
Author: Alfredo Beaumont Sainz <alfredo@toolkom.com>
Date:   Fri May 21 17:23:30 2010 -0400

    gst-plugin: make it build and work

    Successfully tested w/gstreamer 0.10.25.

commit a8e27b2203eb2c1f0266176f5c70d8c5b6102c76
Author: Jarod Wilson <jarod@redhat.com>
Date:   Sat Apr 3 16:18:26 2010 -0400

    libcrystalhd: fix segfault in firmware open

    From Edgar (gimli) Hucek via crystalhd-development google group.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 2517a14d3b5bd5a0f2edbd3aa21497a47928cbcd
Author: Jarod Wilson <jarod@redhat.com>
Date:   Wed Mar 31 23:07:17 2010 -0400

    crystalhd: fix oops on load

    Got overzealous in the prior commit w/the dev_foo printk macros.
    Can't use those if the device struct hasn't been filled in yet.

    Still need to add some modparams to turn on various levels of
    debug spew in the driver. Should be quite silent right now.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 317dbd6dda65b4177627d6417b762c287cefa0e7
Author: Jarod Wilson <jarod@redhat.com>
Date:   Tue Mar 30 17:17:05 2010 -0400

    crystalhd: nuke BCMLOG macros, use std dev_foo ones

    Replace all the BCMLOG macros with standard dev_foo macros that
    are provided by the kernel. Where we can't use dev_foo (due to
    not having a struct device handle handy), just use a good old
    printk.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 00c8c23357545052355f183df5248ce21dfbc7c0
Author: Jarod Wilson <jarod@redhat.com>
Date:   Tue Mar 30 10:11:59 2010 -0400

    crystalhd: add device struct to adapter device struct

    Make life easier for converting to dev_foo printk macros.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 81cbd90b85bac090e23babd59df4e0bee5552e46
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Mar 29 13:08:02 2010 -0400

    crystalhd: fix build on 64-bit systems

    Compile fails w/a message about converting to a pointer from an integer
    of a different size (uint32_t/32-bit value to 64-bit pointer). Just do
    a cast to uintptr_t first, which gets the size right regardless of if we
    are on 32-bit or 64-bit. Not fully tested to be sure its also working as
    expected on 64-bit, but at least it builds...

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit e53180c5c33c850623a0a82cb9623eee634e108e
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Mar 29 13:06:47 2010 -0400

    crystalhd: fix flub in refactoring GetFooFromPib

    OFFSETOF needs a member of BC_PIC_INFO_BLOCK as its second arg.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit eee7bc87d5bc087f962d9574125f37d7bdea6f75
Author: Jarod Wilson <jarod@redhat.com>
Date:   Fri Mar 26 17:14:27 2010 -0400

    crystalhd: fix compile warning in bc_defines.h

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 35afe30a5a4e3bf022d61301b17abd8869ca173b
Author: Jarod Wilson <jarod@redhat.com>
Date:   Fri Mar 26 17:13:13 2010 -0400

    crystalhd: line wrapping fix

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 990fc64a09177f21ba2cebbf1ad56b4fefdb304e
Author: Jarod Wilson <jarod@redhat.com>
Date:   Fri Mar 26 17:11:58 2010 -0400

    crystalhd: fix a typo

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 5f9f9eb8eb85408b9c1e528ed7769824ffe5665b
Author: Jarod Wilson <jarod@redhat.com>
Date:   Fri Mar 26 16:30:47 2010 -0400

    firmware: add firmware for bcm970015 crystalhd

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 7d747d9e11c6c6872367419da23763ce6507c948
Author: Jarod Wilson <jarod@redhat.com>
Date:   Fri Mar 26 16:23:40 2010 -0400

    libcrystalhd: bump library version too

    Support for the BCM970015 is well worth a library version bump too.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 47420b5efc300515b31e06c3058e3301e7fad5c0
Author: Jarod Wilson <jarod@redhat.com>
Date:   Fri Mar 26 16:18:47 2010 -0400

    libcrystalhd: bump so version, 970015 support is worthy

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 975de572de2c848fe1a7f5658fac1a1f59b4ad50
Author: Jarod Wilson <jarod@redhat.com>
Date:   Fri Mar 26 16:10:58 2010 -0400

    libcrystalhd: fix 64-bit build

    It compiles on x86_64... Now to see if it actually works still...

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit b587c34f59e33af57512e676a55b42f8c8d92214
Author: Jarod Wilson <jarod@redhat.com>
Date:   Fri Mar 26 16:09:47 2010 -0400

    libcrystalhd: completely resync with Scott's tree

    Blah. Piecemeal porting sucks. I'm going to be lazy and just make the
    two trees match in one big fell swoop.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 9052f466d2783f2de3066b78ae95faa03b80f03b
Author: Jarod Wilson <jarod@redhat.com>
Date:   Fri Mar 26 15:10:33 2010 -0400

    lib: finish importing the rest of the bcm970015 library support

    From Scott's OS X svn tree.

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 6e66a2f6384f234d44ff6fd2b484c7bd150000f0
Author: Jarod Wilson <jarod@redhat.com>
Date:   Fri Mar 26 15:09:29 2010 -0400

    crystalhd: minor header file fixups

    Amalgamated from Scott's OS X svn tree.

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 7246128bd0b6f96a9fbadd0b88a0fe70998a0b0e
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Mar 25 17:13:23 2010 -0400

    libcrystalhd: finish off the rest of bcm970015 lib support

    Hopefully, anyway. :)

    Ported from Scott's osx svn tree...

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 4619a7dbb115aa88c23ea30ac22d0b3e90382150
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Mar 25 16:52:00 2010 -0400

    crystalhd: fix some compile warnings

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 813af6dc628a1a25039e9d15146719aabdc7815a
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Mar 25 16:47:24 2010 -0400

    libcrystalhd: add initial lib support for bcm970015

    Ported by Scott, then by me to git from his osx svn tree.

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 9d840f0c255e71e21379d1225a1e61089754d3ca
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Mar 25 15:54:48 2010 -0400

    crystalhd: check for vmap failure

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 60da0b2f326ad34051ec744634101abb11ed7aec
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Mar 25 15:54:09 2010 -0400

    crystalhd: more single-threaded support and seq hdr parsing

    Ported from Scott's crystalhd-for-osx tree, svn r32.

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit f79ad8ce54e828031ff3f99a805d08752fd115da
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Mar 25 15:20:29 2010 -0400

    crystalhd: initial support for single-threaded mode

    From Scott Davilla, ported from his crystalhd-for-osx svn tree,
    which was in turn ported from somewhere else... :)

    Signed-off-by: Scott Davilla <davilla@4pi.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 485e26c9ce5a7406d18fa43016598c71e58502a5
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Mar 25 12:36:25 2010 -0400

    crystalhd: add debug printk of register accesses

    The CrystalHD device driver assumes a little endian host. In order to
    verify future work on endianess-independence, this patch adds
    printk's to track the register access to the device.

    This helps verify bitfield endianess correctness as well as any
    hard-coded assumptions in the driver code.

    Signed-off-by: Leon Woestenberg <leon@sidebranch.com>

    Minor formatting modifications and use of __func__ added by Jarod.

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit aed81580a42f89e1f9d9aa6047b14d74fbb994d0
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Mar 25 12:33:46 2010 -0400

    crystalhd: fix deprecated asm/foo include warnings

    Broken out of a larger patch from Lars.

    Signed-off-by: Lars Lindley <lindley@coyote.org>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 70e22f5fcdfdb3464886602e2d7d84632c1a7963
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Mar 25 12:09:20 2010 -0400

    crystalhd: more whitespace fixes

    Broken out from a larger patch from Lars.

    Signed-off-by: Lars Lindley <lindley@coyote.org>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 960586cb6f7866120d6a5a227539873fd3abb54e
Author: Jani Nikula <ext-jani.1.nikula@nokia.com>
Date:   Thu Mar 25 11:36:46 2010 -0400

    crystalhd: fix device_create() return value check

    Use IS_ERR() instead of comparing to NULL.

    Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 34f9fddb17e707d24af286312d60da8555ad49bf
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Mar 25 11:32:47 2010 -0400

    crystalhd: fix some whitespace and coding style issues

    Based on several patches sent my way by numerous people,
    with slight modifications for sanity.

    Signed-off-by: Niklas Gottschalk <gottschalk.niklas@googlemail.com>
    Signed-off-by: Lars Lindley <lindley@coyote.org>
    Signed-off-by: Tomas Dabasinskas <tomas.it@gmail.com>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 8c6d5732a85deae8d080cc51988d5813872fbe82
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Mar 25 11:15:58 2010 -0400

    examples: assorted fixups and Makefile addition

    - Resyncs (mostly) with Scott's crystalhd-for-osx tree
    - Makes mpeg2test actually build (though I don't think it is actually
      functional yet)
    - Adds a Makefile in place of the build shell script

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit ae0fce89fc5f5c3808e1a32b85bbb4cb613005c9
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Feb 25 22:36:42 2010 -0500

    Staging: crystalhd: Misc improvements for crystalhd_lnx.c

    This patch does following improvements:

    1. Follow kernel style for comments
    2. Reorganize code for readability improvement
    3. Use PCI helper macros
    4. Use __devinit, __devexit, __devexit_p at necessary places
    5. Mark functions and data as static when it is not exported

    Signed-off-by: Ameya Palande <2ameya@gmail.com>
    Cc: Naren Sankar <nsankar@broadcom.com>
    Cc: Jarod Wilson <jarod@wilsonet.com>
    Cc: Scott Davilla <davilla@4pi.com>
    Cc: Manu Abraham <abraham.manu@gmail.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit c9b2148479ac6f5926cf8bde317aa0a03e47af65
Merge: eed4d84 888ddb1
Author: Jarod Wilson <jarod@redhat.com>
Date:   Thu Feb 25 22:34:31 2010 -0500

    Merge branch 'master' of git+ssh://wilsonet.com/srv/git/crystalhd

commit 888ddb11740531b33c0205750447a8b717ed5c6c
Author: Anssi Hannula <anssi.hannula@iki.fi>
Date:   Fri Jan 22 22:10:00 2010 +0200

    driver: drop the use of CRYSTALHD_ROOT variable

    Use $(src) instead of defining a CRYSTALHD_ROOT variable at configure
    time. This allows the build to work even when moving the driver directory
    around.

    Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 05e51c500a51e85e9f40228a68ef694451bac907
Author: Anssi Hannula <anssi.hannula@iki.fi>
Date:   Fri Jan 22 21:51:03 2010 +0200

    lib: fix instances of calling printf with int cast to char*

    In DtsProcInput(), there are calls to DebugLog_Trace(_tl, fmt, args...)
    with first argument being a TEXT("message: %x"), and second (char*)sts.

    TEXT is defined to nothingness, so the actual message is passed via the
    unused _tl argument, and sts (status integer) is cast to char* (!) and
    used as the format string.

    Fix the DebugLog_Trace() calls to pass the proper arguments and remove
    the now unused TEXT define.

    Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit c56145298d5be7f80a3f4c27e622b90fe89221ea
Author: Anssi Hannula <anssi.hannula@iki.fi>
Date:   Fri Jan 22 21:41:35 2010 +0200

    lib: link with pthread to avoid undefined symbols

    Fix undefined symbols sem_timedwait, sem_init, sem_post, sem_destroy.

    Signed-off-by: Anssi Hannula <anssi.hannula@iki.fi>
    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit eed4d84f7f5af0707e742e26ee2299ac3db6d110
Author: Dave Airlie <airlied@redhat.com>
Date:   Wed Jan 13 09:52:26 2010 -0500

    driver: fix build on powerpc

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 82bb6578c4e7cafdbbfb898e2eddea5116969e8d
Author: Jarod Wilson <jarod@redhat.com>
Date:   Wed Jan 6 18:08:04 2010 -0500

    lib: fix up for installs to DESTDIR for packaging

    - tested by creating Fedora libcrystalhd rpms

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 2b72053b33c2b2a046d3fce32b0b117bd2fcedc9
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Jan 4 15:45:20 2010 -0500

    driver: further trim what gets exported

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 05e58472454c49fca9d2394d6876ad3f5a03af80
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Jan 4 15:19:29 2010 -0500

    driver: don't include unused headers when exporting to kernel tree

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 82bddc189c958a7fca79e5bd236efaee88a23ce1
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Jan 4 14:18:53 2010 -0500

    examples: d'oh, binary wasn't supposed to go in there

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 245bc5f40de7a15f7ca293a363cd1675f811f1fb
Merge: 5939870 5c3b922
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Jan 4 14:23:45 2010 -0500

    Merge branch 'master' of git+ssh://wilsonet.com/srv/web/git/crystalhd

commit 5c3b9223733429756fd4b7904332e9efff651e9a
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Jan 4 14:16:34 2010 -0500

    driver: add basic export-to-kernel-git-tree script

    Very little error-checking, but hey, it works so far...

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit e2c8385f9c4e6ca558cf10ccda8c58b9a6d198d3
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Jan 4 14:15:15 2010 -0500

    driver: these files are generated, shouldn't be in git

    Signed-off-by: Jarod Wilson <jarod@redhat.com>

commit 5e97daedb372478a61d4800311e782ceaa97a9cd
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Jan 4 14:14:43 2010 -0500

    infra: add .gitignore files

commit 59398702dcffe3fed5df28ad0666e2f4365789fc
Author: Jarod Wilson <jarod@redhat.com>
Date:   Mon Jan 4 14:07:08 2010 -0500

    example: make it build again

    Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/staging/crystalhd/DriverFwShare.h       |   93 +
 drivers/staging/crystalhd/FleaDefs.h            |  188 ++
 drivers/staging/crystalhd/Makefile              |   11 +-
 drivers/staging/crystalhd/bc_dts_defs.h         |  218 +-
 drivers/staging/crystalhd/bc_dts_glob_lnx.h     |   72 +-
 drivers/staging/crystalhd/bcm_70012_regs.h      |    1 -
 drivers/staging/crystalhd/bcm_70015_regs.h      | 1376 +++++++++++
 drivers/staging/crystalhd/crystalhd.h           |    7 +-
 drivers/staging/crystalhd/crystalhd_cmds.c      |  524 ++--
 drivers/staging/crystalhd/crystalhd_cmds.h      |    9 +-
 drivers/staging/crystalhd/crystalhd_flea_ddr.c  |  735 ++++++
 drivers/staging/crystalhd/crystalhd_flea_ddr.h  |   73 +
 drivers/staging/crystalhd/crystalhd_fleafuncs.c | 2952 +++++++++++++++++++++++
 drivers/staging/crystalhd/crystalhd_fleafuncs.h |   62 +
 drivers/staging/crystalhd/crystalhd_fw_if.h     |   52 +-
 drivers/staging/crystalhd/crystalhd_hw.c        | 2381 ++++--------------
 drivers/staging/crystalhd/crystalhd_hw.h        |  601 +++--
 drivers/staging/crystalhd/crystalhd_linkfuncs.c | 2057 ++++++++++++++++
 drivers/staging/crystalhd/crystalhd_linkfuncs.h |  228 ++
 drivers/staging/crystalhd/crystalhd_lnx.c       |  365 +--
 drivers/staging/crystalhd/crystalhd_lnx.h       |   17 +-
 drivers/staging/crystalhd/crystalhd_misc.c      |  376 ++-
 drivers/staging/crystalhd/crystalhd_misc.h      |   76 +-
 23 files changed, 9655 insertions(+), 2819 deletions(-)
 create mode 100644 drivers/staging/crystalhd/DriverFwShare.h
 create mode 100644 drivers/staging/crystalhd/FleaDefs.h
 create mode 100644 drivers/staging/crystalhd/bcm_70015_regs.h
 create mode 100644 drivers/staging/crystalhd/crystalhd_flea_ddr.c
 create mode 100644 drivers/staging/crystalhd/crystalhd_flea_ddr.h
 create mode 100644 drivers/staging/crystalhd/crystalhd_fleafuncs.c
 create mode 100644 drivers/staging/crystalhd/crystalhd_fleafuncs.h
 create mode 100644 drivers/staging/crystalhd/crystalhd_linkfuncs.c
 create mode 100644 drivers/staging/crystalhd/crystalhd_linkfuncs.h

diff --git a/drivers/staging/crystalhd/DriverFwShare.h b/drivers/staging/crystalhd/DriverFwShare.h
new file mode 100644
index 0000000..5017f17
--- /dev/null
+++ b/drivers/staging/crystalhd/DriverFwShare.h
@@ -0,0 +1,93 @@
+#ifndef _DRIVER_FW_SHARE_
+#define _DRIVER_FW_SHARE_
+
+#ifndef USE_MULTI_DECODE_DEFINES
+#define HOST_TO_FW_PIC_DEL_INFO_ADDR		0x400	/*Original single Decode Offset*/
+#else
+#if 0
+#define HOST_TO_FW_PIC_DEL_INFO_ADDR		0x200	/*New offset that we plan to use eventually*/
+#endif
+#define HOST_TO_FW_PIC_DEL_INFO_ADDR		0x400	/*This is just for testing..remove this once tested */
+#endif
+
+
+/*
+ * The TX address does not change between the
+ * single decode and multiple decode.
+ */
+#define TX_BUFF_UPDATE_ADDR					0x300	/*This is relative to BORCH */
+
+typedef
+struct
+_PIC_DELIVERY_HOST_INFO_
+{
+/*
+-- The list ping-pong code is already there in the driver
+-- to save from re-inventing the code, the driver will indicate
+-- to firmware on which list the command should be posted.
+ */
+	unsigned int ListIndex;
+	unsigned int HostDescMemLowAddr_Y;
+	unsigned int HostDescMemHighAddr_Y;
+	unsigned int HostDescMemLowAddr_UV;
+	unsigned int HostDescMemHighAddr_UV;
+	unsigned int RxSeqNumber;
+	unsigned int ChannelID;
+	unsigned int Reserved[1];
+}PIC_DELIVERY_HOST_INFO,
+*PPIC_DELIVERY_HOST_INFO;
+
+/*
+-- We write the driver's FLL to this memory location.
+-- This is the array for FLL of all the channels.
+*/
+#define HOST_TO_FW_FLL_ADDR			(HOST_TO_FW_PIC_DEL_INFO_ADDR + sizeof(PIC_DELIVERY_HOST_INFO))
+
+
+enum DRIVER_FW_FLAGS{
+	DFW_FLAGS_CLEAR			=0,
+	DFW_FLAGS_TX_ABORT		=BC_BIT(0),	/*Firmware is stopped and will not give anymore buffers. */
+	DFW_FLAGS_WRAP			=BC_BIT(1)	/*Instruct the Firmware to WRAP the input buffer pointer */
+};
+
+struct TX_INPUT_BUFFER_INFO
+{
+	unsigned int DramBuffAdd;			/* Address of the DRAM buffer where the data can be pushed*/
+	unsigned int DramBuffSzInBytes;		/* Size of the available DRAM buffer, in bytes*/
+	unsigned int HostXferSzInBytes;		/* Actual Transfer Done By Host, In Bytes*/
+	unsigned int Flags;					/* DRIVER_FW_FLAGS Written By Firmware to handle Stop of TX*/
+	unsigned int SeqNum;				/* Sequence number of the tranfer that is done. Read-Modify-Write*/
+	unsigned int ChannelID;				/* To which Channel this buffer belongs to*/
+	unsigned int Reserved[2];
+};
+
+
+/*
+-- Out of band firmware handshake.
+=====================================
+-- The driver writes the SCRATCH-8 register with a Error code.
+-- The driver then writes a mailbox register with 0x01.
+-- The driver then polls for the ACK. This ack is if the value of the SCRATCH-8 becomes zero.
+*/
+
+#define OOB_ERR_CODE_BASE		70015
+enum OUT_OF_BAND_ERR_CODE
+{
+	OOB_INVALID				= 0,
+	OOB_CODE_ACK			= OOB_ERR_CODE_BASE,
+	OOB_CODE_STOPRX			= OOB_ERR_CODE_BASE + 1,
+};
+
+
+#define OOB_CMD_RESPONSE_REGISTER		BCHP_ARMCR4_BRIDGE_REG_SCRATCH_8
+#define OOB_PCI_TO_ARM_MBOX				BCHP_ARMCR4_BRIDGE_REG_MBOX_ARM3
+#define TX_BUFFER_AVAILABLE_INTR		BCHP_ARMCR4_BRIDGE_REG_MBOX_PCI3
+#define HEART_BEAT_REGISTER				BCHP_ARMCR4_BRIDGE_REG_SCRATCH_1
+#define HEART_BEAT_POLL_CNT				5
+
+
+#define FLEA_WORK_AROUND_SIG			0xF1EA
+#define RX_PIC_Q_STS_WRKARND			BC_BIT(0)
+#define RX_DRAM_WRITE_WRKARND			BC_BIT(1)
+#define RX_MBOX_WRITE_WRKARND			BC_BIT(2)
+#endif
diff --git a/drivers/staging/crystalhd/FleaDefs.h b/drivers/staging/crystalhd/FleaDefs.h
new file mode 100644
index 0000000..439d961
--- /dev/null
+++ b/drivers/staging/crystalhd/FleaDefs.h
@@ -0,0 +1,188 @@
+#ifndef _FLEA_DEFS_
+#define _FLEA_DEFS_
+
+/*
+* Include a whole bunch of RDB files for register definitions
+*/
+#include "bcm_70015_regs.h"
+
+/* Assume we have 64MB DRam */
+#define FLEA_TOTAL_DRAM_SIZE		64*1024*1024
+#define FLEA_GISB_DIRECT_BASE		0x50
+
+/*- These definition of the ADDRESS and DATA
+  - Registers are not there in RDB.
+ */
+#define FLEA_GISB_INDIRECT_ADDRESS	0xFFF8
+#define FLEA_GISB_INDIRECT_DATA		0xFFFC
+
+/*
+ * POLL count for Flea.
+ */
+#define FLEA_MAX_POLL_CNT		1000
+
+/*
+ -- Flea Firmware Signature length (128 bit)
+ */
+#define FLEA_FW_SIG_LEN_IN_BYTES	16
+#define LENGTH_FIELD_SIZE			4
+#define FLEA_FW_SIG_LEN_IN_DWORD	(FLEA_FW_SIG_LEN_IN_BYTES/4)
+#define FW_DOWNLOAD_START_ADDR		0
+
+/*
+ * Some macros to ease the bit specification from RDB
+ */
+#define SCRAM_KEY_DONE_INT_BIT	BC_BIT(BCHP_WRAP_MISC_INTR2_CPU_STATUS_SCRM_KEY_DONE_INTR_SHIFT)
+#define BOOT_VER_DONE_BIT		BC_BIT(BCHP_WRAP_MISC_INTR2_CPU_STATUS_BOOT_VER_DONE_INTR_SHIFT)
+#define BOOT_VER_FAIL_BIT		BC_BIT(BCHP_WRAP_MISC_INTR2_CPU_STATUS_BOOT_VER_FAIL_INTR_SHIFT)
+#define SHARF_ERR_INTR			BC_BIT(BCHP_WRAP_MISC_INTR2_CPU_STATUS_SHARF_ERR_INTR_SHIFT)
+#define SCRUB_ENABLE_BIT		BC_BIT(BCHP_SCRUB_CTRL_SCRUB_ENABLE_SCRUB_EN_SHIFT)
+#define DRAM_SCRAM_ENABLE_BIT	BC_BIT(BCHP_SCRUB_CTRL_SCRUB_ENABLE_DSCRAM_EN_SHIFT)
+#define ARM_RUN_REQ_BIT			BC_BIT(BCHP_ARMCR4_BRIDGE_REG_BRIDGE_CTL_arm_run_request_SHIFT)
+#define GetScrubEndAddr(_Sz)	((FW_DOWNLOAD_START_ADDR + (_Sz - FLEA_FW_SIG_LEN_IN_BYTES -LENGTH_FIELD_SIZE-1))& (BCHP_SCRUB_CTRL_BORCH_END_ADDRESS_BORCH_END_ADDR_MASK))
+
+/*
+-- Firmware Command Interface Definitions.
+-- We use BCHP_ARMCR4_BRIDGE_REG_MBOX_PCI1 as host to FW mailbox.
+-- We use BCHP_ARMCR4_BRIDGE_REG_MBOX_ARM1 as FW to Host mailbox.
+*/
+
+/* Address where the command parameters are written. */
+#define DDRADDR_4_FWCMDS		0x100
+
+/* */
+/* mailbox used for passing the FW Command address (DDR address) to */
+/* firmware. */
+/* */
+#define FW_CMD_POST_MBOX		BCHP_ARMCR4_BRIDGE_REG_MBOX_ARM1
+
+/* Once we get a firmware command done interrupt, */
+/* we will need to get the address of the response. */
+/* This mailbox is written by FW before asserting the */
+/* firmware command done interrupt. */
+#define FW_CMD_RES_MBOX			BCHP_ARMCR4_BRIDGE_REG_MBOX_PCI1
+
+/*
+-- RxDMA Picture QStatus Mailbox.
+-- RxDMA Picture Post Mailbox. < Write DDR address to this mailbox >
+ */
+#define RX_DMA_PIC_QSTS_MBOX		BCHP_ARMCR4_BRIDGE_REG_MBOX_PCI2
+#define RX_POST_MAILBOX				BCHP_ARMCR4_BRIDGE_REG_MBOX_ARM2
+#define RX_POST_CONFIRM_SCRATCH		BCHP_ARMCR4_BRIDGE_REG_SCRATCH_5
+#define RX_START_SEQ_NUMBER			1
+#define INDICATE_TX_DONE_REG		BCHP_ARMCR4_BRIDGE_REG_SCRATCH_9
+
+/*
+-- At the end of the picture frame there is the Link's Y0 data
+-- and there is Width data. The driver will copy this 32 bit data to Y[0]
+-- location. This makes the Flea PIB compatible with Link.
+-- Also note that Flea is capable of putting out the odd size picture widths
+-- so the PicWidth field is the actual picture width of the picture. In link
+-- We were only getting 1920,1280 or 720 as picture widths.
+*/
+#define PIC_PIB_DATA_OFFSET_FROM_END	4
+#define PIC_PIB_DATA_SIZE_IN_BYTES		4	/*The data that use to be in Y[0] component */
+#define PIC_WIDTH_OFFSET_FROM_END		8	/*Width information for the driver. */
+#define PIC_WIDTH_DATA_SIZE_IN_BYTES	4	/*Width information for the driver. */
+
+/*
+-- The format change PIB comes in a dummy frame now.
+-- The Width field has the format change flag (bit-31) which
+-- the driver uses to detect the format change now.
+*/
+#define PIB_FORMAT_CHANGE_BIT			BC_BIT(31)
+#define PIB_EOS_DETECTED_BIT			BC_BIT(30)
+
+#define FLEA_DECODE_ERROR_FLAG			0x800
+
+/*
+-- Interrupt Mask, Set and Clear registers are exactly
+-- same as the interrupt status register. We will
+-- Use the following union for all the registers.
+*/
+
+union FLEA_INTR_BITS_COMMON
+{
+	struct
+	{
+		uint32_t	L0TxDMADone:1;		/* Bit-0 */
+		uint32_t	L0TxDMAErr:1;		/* Bit-1 */
+		uint32_t	L0YRxDMADone:1;		/* Bit-2 */
+		uint32_t	L0YRxDMAErr:1;		/* Bit-3 */
+		uint32_t	L0UVRxDMADone:1;	/* Bit-4 */
+		uint32_t	L0UVRxDMAErr:1;		/* Bit-5 */
+		uint32_t	Reserved1:2;		/* Bit-6-7 */
+		uint32_t	L1TxDMADone:1;		/* Bit-8 */
+		uint32_t	L1TxDMAErr:1;		/* Bit-9 */
+		uint32_t	L1YRxDMADone:1;		/* Bit-10 */
+		uint32_t	L1YRxDMAErr:1;		/* Bit-11 */
+		uint32_t	L1UVRxDMADone:1;	/* Bit-12 */
+		uint32_t	L1UVRxDMAErr:1;		/* Bit-13 */
+		uint32_t	Reserved2:2;		/* Bit-14-15 */
+		uint32_t	ArmMbox0Int:1;		/* Bit-16 */
+		uint32_t	ArmMbox1Int:1;		/* Bit-17 */
+		uint32_t	ArmMbox2Int:1;		/* Bit-18 */
+		uint32_t	ArmMbox3Int:1;		/* Bit-19 */
+		uint32_t	Reserved3:4;		/* Bit-20-23 */
+		uint32_t	PcieTgtUrAttn:1;	/* Bit-24 */
+		uint32_t	PcieTgtCaAttn:1;	/* Bit-25 */
+		uint32_t	HaltIntr:1;			/* Bit-26 */
+		uint32_t	Reserved4:5;			/* Bit-27-31 */
+	};
+
+	 uint32_t	WholeReg;
+};
+
+/*
+================================================================
+-- Flea power state machine
+-- FLEA_PS_NONE
+--	Enter to this state when system boots up and device is not open.
+-- FLEA_PS_ACTIVE:
+--	1. Set when the device is started and FW downloaded.
+--	2. We come to this state from FLEA_PS_LP_COMPLETE when
+--		2.a Free list length becomes greater than X. [Same As Internal Pause Sequence]
+--		2.b There is a firmware command issued.
+--  3. We come to this state from FLEA_PS_LP_PENDING when
+--		3.a Free list length becomes greater than X. [Same As Internal Pause Sequence]
+--		3.b There is a firmware command Issued.
+-- FLEA_PS_LP_PENDING
+--	1. Enter to this state from FLEA_PS_ACTIVE
+--		1.a FLL becomes greater less than Y[Same as Internal Resume].
+-- FLEA_PS_LP_COMPLETE
+--	1. Enter in to this state from FLEA_PS_LP_PENDING
+--		1.a There are no Pending TX, RX, and FW Command.
+--	2. Enter to This state when the handle is closed.
+--  3. Enter to this state From ACTIVE
+--		3.a FLL < Y.
+--		3.b There is no TX,RX and FW pending.
+--  4. Enter this state when RX is not running, either before it is started or after it is stopped.
+=================================================================
+*/
+
+enum FLEA_POWER_STATES {
+	FLEA_PS_NONE=0,
+	FLEA_PS_STOPPED,
+	FLEA_PS_ACTIVE,
+	FLEA_PS_LP_PENDING,
+	FLEA_PS_LP_COMPLETE
+};
+
+enum FLEA_STATE_CH_EVENT {
+	FLEA_EVT_NONE=0,
+	FLEA_EVT_START_DEVICE,
+	FLEA_EVT_STOP_DEVICE,
+	FLEA_EVT_FLL_CHANGE,
+	FLEA_EVT_FW_CMD_POST,
+	FLEA_EVT_CMD_COMP
+};
+
+#define TEST_BIT(_value_,_bit_number_)	(_value_ & (0x00000001 << _bit_number_))
+
+#define CLEAR_BIT(_value_,_bit_number_)\
+{_value_ = _value_ & (~(0x00000001 << _bit_number_));}
+
+#define SET_BIT(_value_,_bit_number_)\
+{_value_ |=  (0x01 << _bit_number_);}
+
+#endif
diff --git a/drivers/staging/crystalhd/Makefile b/drivers/staging/crystalhd/Makefile
index c31657a..b3a07d2 100644
--- a/drivers/staging/crystalhd/Makefile
+++ b/drivers/staging/crystalhd/Makefile
@@ -1,6 +1,9 @@
 obj-$(CONFIG_CRYSTALHD)	+= crystalhd.o
 
-crystalhd-y		:= crystalhd_cmds.o	\
-			   crystalhd_hw.o	\
-			   crystalhd_lnx.o	\
-			   crystalhd_misc.o
+crystalhd-y		:= crystalhd_lnx.o \
+			   crystalhd_misc.o \
+			   crystalhd_cmds.o \
+			   crystalhd_hw.o \
+			   crystalhd_linkfuncs.o \
+			   crystalhd_fleafuncs.o \
+			   crystalhd_flea_ddr.o
diff --git a/drivers/staging/crystalhd/bc_dts_defs.h b/drivers/staging/crystalhd/bc_dts_defs.h
index 647e116..39cf77d 100644
--- a/drivers/staging/crystalhd/bc_dts_defs.h
+++ b/drivers/staging/crystalhd/bc_dts_defs.h
@@ -58,16 +58,22 @@ enum BC_STATUS {
 	BC_STS_CERT_VERIFY_ERROR = 23,
 	BC_STS_DEC_EXIST_OPEN	= 24,
 	BC_STS_PENDING		= 25,
-	BC_STS_CLK_NOCHG	= 26,
+	BC_STS_PWR_MGMT		= 26,
 
 	/* Must be the last one.*/
 	BC_STS_ERROR		= -1
 };
 
+enum BC_HW_STATE {
+	BC_HW_RUNNING	= 0,
+	BC_HW_SUSPEND	= 1,
+	BC_HW_RESUME	= 2
+};
+
 /*------------------------------------------------------*
  *    Registry Key Definitions				*
  *------------------------------------------------------*/
-#define BC_REG_KEY_MAIN_PATH	"Software\\Broadcom\\MediaPC\\70010"
+#define BC_REG_KEY_MAIN_PATH	"Software\\Broadcom\\MediaPC\\CrystalHD"
 #define BC_REG_KEY_FWPATH		"FirmwareFilePath"
 #define BC_REG_KEY_SEC_OPT		"DbgOptions"
 
@@ -90,8 +96,8 @@ struct BC_REG_CONFIG {
 	uint32_t		DbgOptions;
 };
 
-#if defined(__KERNEL__) || defined(__LINUX_USER__)
-#else
+/*#if defined(__KERNEL__) || defined(__LINUX_USER__) */
+#if defined(_WIN32) || defined(_WIN64)
 /* Align data structures */
 #define ALIGN(x)	__declspec(align(x))
 #endif
@@ -125,7 +131,11 @@ enum DtsDeviceFixMode {
 	DTS_ADAPTIVE_OUTPUT_PER	= BC_BIT(17),
 	DTS_INTELLIMAP		= BC_BIT(18),
 	/* b[19]-b[21] : select clock frequency */
-	DTS_PLAYBACK_DROP_RPT_MODE = BC_BIT(22)
+	DTS_PLAYBACK_DROP_RPT_MODE = BC_BIT(22),
+	DTS_DIAG_TEST_MODE = BC_BIT(23),
+	DTS_SINGLE_THREADED_MODE = BC_BIT(24),
+	DTS_FILTER_MODE = BC_BIT(25),
+	DTS_MFT_MODE = BC_BIT(26)
 };
 
 #define DTS_DFLT_RESOLUTION(x)	(x<<11)
@@ -155,6 +165,7 @@ enum DtsSetVideoParamsAlgo {
 	BC_VID_ALGO_H264		= 0,
 	BC_VID_ALGO_MPEG2		= 1,
 	BC_VID_ALGO_VC1			= 4,
+	BC_VID_ALGO_DIVX		= 6,
 	BC_VID_ALGO_VC1MP		= 7,
 };
 
@@ -234,7 +245,7 @@ struct BC_PIB_EXT_VC1 {
 /*------------------------------------------------------*
  *    Picture Information Block				*
  *------------------------------------------------------*/
-#if defined(__LINUX_USER__)
+#if !defined(__KERNEL__)
 /* Values for 'pulldown' field.  '0' means no pulldown information
  * was present for this picture. */
 enum {
@@ -262,6 +273,8 @@ enum {
 	vdecFrameRate50,
 	vdecFrameRate59_94,
 	vdecFrameRate60,
+	vdecFrameRate14_985,
+	vdecFrameRate7_496,
 };
 
 /* Values for the 'aspect_ratio' field. */
@@ -390,13 +403,8 @@ enum {
 
 #define VDEC_FLAG_PICTURE_META_DATA_PRESENT	(0x40000)
 
-#endif /* __LINUX_USER__ */
+#endif /* __KERNEL__ */
 
-enum _BC_OUTPUT_FORMAT {
-	MODE420				= 0x0,
-	MODE422_YUY2			= 0x1,
-	MODE422_UYVY			= 0x2,
-};
 /**
  * struct BC_PIC_INFO_BLOCK
  * @timeStam;: Timestamp
@@ -453,11 +461,13 @@ struct BC_PIC_INFO_BLOCK {
  */
 enum POUT_OPTIONAL_IN_FLAGS_ {
 	/* Flags from App to Device */
-	BC_POUT_FLAGS_YV12	  = 0x01,
-	BC_POUT_FLAGS_STRIDE	  = 0x02,
-	BC_POUT_FLAGS_SIZE	  = 0x04,
-	BC_POUT_FLAGS_INTERLACED  = 0x08,
-	BC_POUT_FLAGS_INTERLEAVED = 0x10,
+	BC_POUT_FLAGS_YV12	  = 0x01,	/* Copy Data in YV12 format */
+	BC_POUT_FLAGS_STRIDE	  = 0x02,	/* Stride size is valid. */
+	BC_POUT_FLAGS_SIZE	  = 0x04,	/* Take size information from Application */
+	BC_POUT_FLAGS_INTERLACED  = 0x08,	/* copy only half the bytes */
+	BC_POUT_FLAGS_INTERLEAVED = 0x10,	/* interleaved frame */
+	BC_POUT_FLAGS_STRIDE_UV	  = 0x20,	/* Stride size is valid (for UV buffers). */
+	BC_POUT_FLAGS_MODE	  = 0x40,	/* Take output mode from Application, overrides YV12 flag if on */
 
 	/* Flags from Device to APP */
 	BC_POUT_FLAGS_FMT_CHANGE  = 0x10000,
@@ -466,8 +476,23 @@ enum POUT_OPTIONAL_IN_FLAGS_ {
 	BC_POUT_FLAGS_FLD_BOT	  = 0x80000,
 };
 
+/*Decoder Capability */
+enum DECODER_CAP_FLAGS
+{
+	BC_DEC_FLAGS_H264		= 0x01,
+	BC_DEC_FLAGS_MPEG2		= 0x02,
+	BC_DEC_FLAGS_VC1		= 0x04,
+	BC_DEC_FLAGS_M4P2		= 0x08,	/*MPEG-4 Part 2: Divx, Xvid etc. */
+};
+
+#if defined(__KERNEL__) || defined(__LINUX_USER__) || defined(__LINUX__)
 typedef enum BC_STATUS(*dts_pout_callback)(void  *shnd, uint32_t width,
-			uint32_t height, uint32_t stride, void *pOut);
+                                 uint32_t height, uint32_t stride, void *pOut);
+#else
+typedef enum BC_STATUS(*dts_pout_callback)(void  *shnd,
+                        uint32_t width, uint32_t height, uint32_t stride,
+                        struct _BC_DTS_PROC_OUT *pOut);
+#endif
 
 /* Line 21 Closed Caption */
 /* User Data */
@@ -515,6 +540,7 @@ struct BC_DTS_PROC_OUT {
 	uint8_t		b422Mode;
 	uint8_t		bPibEnc;
 	uint8_t		bRevertScramble;
+	uint32_t	StrideSzUV;		/* Caller supplied Stride Size */
 
 };
 /**
@@ -543,16 +569,34 @@ struct BC_DTS_STATUS {
 	uint8_t		FreeListCount;
 	uint8_t		PowerStateChange;
 	uint8_t		reserved_[1];
-	uint32_t	FramesDropped;
-	uint32_t	FramesCaptured;
-	uint32_t	FramesRepeated;
-	uint32_t	InputCount;
-	uint64_t	InputTotalSize;
-	uint32_t	InputBusyCount;
-	uint32_t	PIBMissCount;
-	uint32_t	cpbEmptySize;
-	uint64_t	NextTimeStamp;
-	uint8_t		reserved__[16];
+
+	uint32_t	FramesDropped;	/* Number of frames dropped.  (reported by DIL) */
+	uint32_t	FramesCaptured;	/* Number of frames captured. (reported by DIL) */
+	uint32_t	FramesRepeated;	/* Number of frames repeated. (reported by DIL) */
+
+	uint32_t	InputCount;	/* Times compressed video has been sent to the HW.
+					 * i.e. Successful DtsProcInput() calls (reported by DIL) */
+	uint64_t	InputTotalSize;	/* Amount of compressed video that has been sent to the HW.
+					 * (reported by DIL) */
+	uint32_t	InputBusyCount;	/* Times compressed video has attempted to be sent to the HW
+					 * but the input FIFO was full. (reported by DIL) */
+
+	uint32_t	PIBMissCount;	/* Amount of times a PIB is invalid. (reported by DIL) */
+
+	uint32_t	cpbEmptySize;	/* supported only for H.264, specifically changed for
+					 * SingleThreadedAppMode. Report size of CPB buffer available.
+					 * Reported by DIL */
+	uint64_t	NextTimeStamp;	/* TimeStamp of the next picture that will be returned
+					 * by a call to ProcOutput. Added for SingleThreadedAppMode.
+					 * Reported back from the driver */
+	uint8_t		TxBufData;
+
+	uint8_t		reserved__[3];
+
+	uint32_t	picNumFlags; /* Picture number and flags of the next picture to be delivered from the driver */
+
+	uint8_t		reserved___[8];
+
 };
 
 #define BC_SWAP32(_v)			\
@@ -568,5 +612,123 @@ struct BC_DTS_STATUS {
 #define WM_AGENT_TRAYICON_DECODER_RUN	10005
 #define WM_AGENT_TRAYICON_DECODER_PAUSE	10006
 
+#define MAX_COLOR_SPACES	3
+
+enum BC_OUTPUT_FORMAT {
+	MODE420			= 0x0,
+	MODE422_YUY2		= 0x1,
+	MODE422_UYVY		= 0x2,
+	OUTPUT_MODE420		= 0x0,
+	OUTPUT_MODE422_YUY2	= 0x1,
+	OUTPUT_MODE422_UYVY	= 0x2,
+	OUTPUT_MODE420_NV12	= 0x0,
+	OUTPUT_MODE_INVALID	= 0xFF,
+};
+
+struct BC_COLOR_SPACES {
+        enum BC_OUTPUT_FORMAT	OutFmt[MAX_COLOR_SPACES];
+	uint16_t		Count;
+};
+
+
+enum BC_CAPS_FLAGS {
+	PES_CONV_SUPPORT	= 1,	/*Support PES Conversion*/
+	MULTIPLE_DECODE_SUPPORT	= 2	/*Support multiple stream decode*/
+};
+
+struct BC_HW_CAPABILITY {
+	enum BC_CAPS_FLAGS		flags;
+	struct BC_COLOR_SPACES		ColorCaps;
+	void*			Reserved1;	/* Expansion Of API */
+
+	/*Decoder Capability */
+	uint32_t		DecCaps;	/*DECODER_CAP_FLAGS */
+};
+
+struct BC_SCALING_PARAMS {
+	uint32_t	sWidth;
+	uint32_t	sHeight;
+	uint32_t	DNR;
+	uint32_t	Reserved1;	/*Expansion Of API*/
+	uint8_t		*Reserved2;	/*Expansion OF API*/
+	uint32_t	Reserved3;	/*Expansion Of API*/
+	uint8_t		*Reserved4;	/*Expansion Of API*/
+
+};
+
+enum BC_MEDIA_SUBTYPE {
+	BC_MSUBTYPE_INVALID = 0,
+	BC_MSUBTYPE_MPEG1VIDEO,
+	BC_MSUBTYPE_MPEG2VIDEO,
+	BC_MSUBTYPE_H264,
+	BC_MSUBTYPE_WVC1,
+	BC_MSUBTYPE_WMV3,
+	BC_MSUBTYPE_AVC1,
+	BC_MSUBTYPE_WMVA,
+	BC_MSUBTYPE_VC1,
+	BC_MSUBTYPE_DIVX,
+	BC_MSUBTYPE_DIVX311,
+	BC_MSUBTYPE_OTHERS	/*Types to facilitate PES conversion*/
+};
+
+struct BC_INPUT_FORMAT {
+	int         FGTEnable;      /*Enable processing of FGT SEI*/
+	int         MetaDataEnable; /*Enable retrieval of picture metadata to be sent to video pipeline.*/
+	int         Progressive;    /*Instruct decoder to always try to send back progressive
+				     frames. If input content is 1080p, the decoder will
+				     ignore pull-down flags and always give 1080p output.
+				     If 1080i content is processed, the decoder will return
+				     1080i data. When this flag is not set, the decoder will
+				     use pull-down information in the input stream to decide
+				     the decoded data format.*/
+	uint32_t    OptFlags;       /*In this field bits 0:3 are used pass default frame rate, bits 4:5 are for operation mode
+				     (used to indicate Blu-ray mode to the decoder) and bit 6 is for the flag mpcOutPutMaxFRate
+				     which when set tells the FW to output at the max rate for the resolution and ignore the
+				     frame rate determined from the stream. Bit 7 is set to indicate that this is single threaded
+				     mode and the driver will be peeked to get timestamps ahead of time*/
+	enum BC_MEDIA_SUBTYPE mSubtype;  /* Video Media Type*/
+	uint32_t    width;
+	uint32_t    height;
+	uint32_t    startCodeSz;    /*Start code size for H264 clips*/
+	uint8_t     *pMetaData;     /*Metadata buffer that is used to pass sequence header*/
+	uint32_t    metaDataSz;     /*Metadata size*/
+	uint8_t     bEnableScaling;
+	struct BC_SCALING_PARAMS ScalingParams;
+};
+
+struct BC_INFO_CRYSTAL {
+	uint8_t device;
+	union {
+		struct {
+			uint32_t dilRelease:8;
+			uint32_t dilMajor:8;
+			uint32_t dilMinor:16;
+		};
+		uint32_t version;
+	} dilVersion;
+
+	union {
+		struct {
+			uint32_t drvRelease:4;
+			uint32_t drvMajor:8;
+			uint32_t drvMinor:12;
+			uint32_t drvBuild:8;
+		};
+		uint32_t version;
+	} drvVersion;
+
+	union {
+		struct {
+			uint32_t fwRelease:4;
+			uint32_t fwMajor:8;
+			uint32_t fwMinor:12;
+			uint32_t fwBuild:8;
+		};
+		uint32_t version;
+	} fwVersion;
+
+	uint32_t Reserved1; /* For future expansion */
+	uint32_t Reserved2; /* For future expansion */
+};
 
 #endif	/* _BC_DTS_DEFS_H_ */
diff --git a/drivers/staging/crystalhd/bc_dts_glob_lnx.h b/drivers/staging/crystalhd/bc_dts_glob_lnx.h
index 981708f..f12548c 100644
--- a/drivers/staging/crystalhd/bc_dts_glob_lnx.h
+++ b/drivers/staging/crystalhd/bc_dts_glob_lnx.h
@@ -28,7 +28,7 @@
 #ifndef _BC_DTS_GLOB_LNX_H_
 #define _BC_DTS_GLOB_LNX_H_
 
-#ifdef __LINUX_USER__
+#if !defined(__KERNEL__)
 #include <stdio.h>
 #include <stdlib.h>
 #include <unistd.h>
@@ -53,6 +53,17 @@
 #define CRYSTALHD_API_NAME	"crystalhd"
 #define CRYSTALHD_API_DEV_NAME	"/dev/crystalhd"
 
+enum _BC_PCI_DEV_IDS{
+	BC_PCI_DEVID_INVALID = 0,
+	BC_PCI_DEVID_DOZER   = 0x1610,
+	BC_PCI_DEVID_TANK    = 0x1620,
+	BC_PCI_DEVID_LINK	 = 0x1612,
+	BC_PCI_DEVID_LOCKE	 = 0x1613,
+	BC_PCI_DEVID_DEMOBRD = 0x7411,
+	BC_PCI_DEVID_MORPHEUS = 0x7412,
+	BC_PCI_DEVID_FLEA	= 0x1615,
+};
+
 /*
  * These are SW stack tunable parameters shared
  * between the driver and the application.
@@ -64,11 +75,24 @@ enum BC_DTS_GLOBALS {
 	BC_LINK_MAX_OPENS	= 3,	/* Maximum simultaneous opens*/
 	BC_LINK_MAX_SGLS	= 1024,	/* Maximum SG elements 4M/4K */
 	BC_TX_LIST_CNT		= 2,		/* Max Tx DMA Rings */
-	BC_RX_LIST_CNT		= 8,		/* Max Rx DMA Rings*/
-	BC_PROC_OUTPUT_TIMEOUT	= 3000,		/* Milliseconds */
+	BC_RX_LIST_CNT		= 16,		/* Max Rx DMA Rings*/
+	BC_PROC_OUTPUT_TIMEOUT	= 2000,		/* Milliseconds */
 	BC_INFIFO_THRESHOLD	= 0x10000,
 };
 
+/* definitions for HW Pause */
+/* NAREN FIXME temporarily disable HW PAUSE */
+#define HW_PAUSE_THRESHOLD (BC_RX_LIST_CNT)
+#define HW_RESUME_THRESHOLD (BC_RX_LIST_CNT/2)
+
+typedef union _addr_64_ {
+	struct {
+		uint32_t	low_part;
+		uint32_t	high_part;
+	};
+	uint64_t	full_addr;
+} addr_64;
+
 struct BC_CMD_REG_ACC {
 	uint32_t		Offset;
 	uint32_t		Value;
@@ -128,7 +152,7 @@ struct BC_DTS_STATS {
 	uint8_t			drvRLL;
 	uint8_t			drvFLL;
 	uint8_t			eosDetected;
-	uint8_t			pwr_state_change;
+	uint8_t			pwr_state_change; /* 0 is Default (running/stopped), 1 is going to suspend, 2 is going to resume */
 
 	/* Stats from App */
 	uint32_t		opFrameDropped;
@@ -151,7 +175,17 @@ struct BC_DTS_STATS {
 	uint32_t		DrvPIBMisses;
 	uint32_t		DrvPauseTime;
 	uint32_t		DrvRepeatedFrms;
-	uint32_t		res1[13];
+	/*
+	 * BIT-31 MEANS READ Next PIB Info.
+	 * Width will be in bit 0-16.
+	 */
+	uint64_t		DrvNextMDataPLD;
+	uint32_t		DrvcpbEmptySize;
+
+	float			Temperature;
+	uint32_t		TempFromDriver;
+	uint32_t		picNumFlags;
+	uint32_t		res1[7];
 
 };
 
@@ -183,9 +217,14 @@ enum DECOUT_COMPLETION_FLAGS {
 	COMP_FLAG_DATA_BOT	= 0x10,
 };
 
-struct BC_DEC_OUT_BUFF {
+struct BC_DEC_OUT_BUFF{
+#if !defined(__KERNEL__)
+	BC_DEC_YUV_BUFFS	OutPutBuffs;
+	c011_pib		PibInfo;
+#else
 	struct BC_DEC_YUV_BUFFS	OutPutBuffs;
-	struct BC_PIC_INFO_BLOCK PibInfo;
+	struct c011_pib		PibInfo;
+#endif
 	uint32_t		Flags;
 	uint32_t		BadFrCnt;
 };
@@ -195,11 +234,6 @@ struct BC_NOTIFY_MODE {
 	uint32_t		Rsvr[3];
 };
 
-struct BC_CLOCK {
-	uint32_t		clk;
-	uint32_t		Rsvr[3];
-};
-
 struct BC_IOCTL_DATA {
 	enum BC_STATUS		RetSts;
 	uint32_t		IoctlDataSz;
@@ -218,7 +252,6 @@ struct BC_IOCTL_DATA {
 		struct BC_FLUSH_RX_CAP	FlushRxCap;
 		struct BC_DTS_STATS	drvStat;
 		struct BC_NOTIFY_MODE	NotifyMode;
-		struct BC_CLOCK		clockValue;
 	} u;
 	struct _BC_IOCTL_DATA	*next;
 };
@@ -246,8 +279,8 @@ enum BC_DRV_CMD {
 	DRV_CMD_RST_DRV_STAT,	/* Reset Driver Internal Statistics */
 	DRV_CMD_NOTIFY_MODE,	/* Notify the Mode to driver
 			in which the application is Operating*/
-	DRV_CMD_CHANGE_CLOCK,	/* Change the core clock to either save power
-			or improve performance */
+	DRV_CMD_RELEASE,	/* Notify the driver to release user handle
+			and application resources */
 
 	/* MUST be the last one.. */
 	DRV_CMD_END,			/* End of the List.. */
@@ -278,7 +311,7 @@ enum BC_DRV_CMD {
 #define BCM_IOC_RST_DRV_STAT	BC_IOC_IOWR(DRV_CMD_RST_DRV_STAT, BC_IOCTL_MB)
 #define BCM_IOC_NOTIFY_MODE	BC_IOC_IOWR(DRV_CMD_NOTIFY_MODE, BC_IOCTL_MB)
 #define	BCM_IOC_FW_DOWNLOAD	BC_IOC_IOWR(DRV_CMD_FW_DOWNLOAD, BC_IOCTL_MB)
-#define BCM_IOC_CHG_CLK		BC_IOC_IOWR(DRV_CMD_CHANGE_CLOCK, BC_IOCTL_MB)
+#define BCM_IOC_RELEASE		BC_IOC_IOWR(DRV_CMD_RELEASE, BC_IOCTL_MB)
 #define	BCM_IOC_END		BC_IOC_VOID
 
 /* Wrapper for main IOCTL data */
@@ -292,9 +325,10 @@ struct crystalhd_ioctl_data {
 };
 
 enum crystalhd_kmod_ver {
-	crystalhd_kmod_major	= 0,
-	crystalhd_kmod_minor	= 9,
-	crystalhd_kmod_rev	= 27,
+	crystalhd_kmod_major	= 3,
+	crystalhd_kmod_minor	= 10,
+	crystalhd_kmod_rev		= 1,
 };
 
+
 #endif
diff --git a/drivers/staging/crystalhd/bcm_70012_regs.h b/drivers/staging/crystalhd/bcm_70012_regs.h
index f3ab314..1b069f2 100644
--- a/drivers/staging/crystalhd/bcm_70012_regs.h
+++ b/drivers/staging/crystalhd/bcm_70012_regs.h
@@ -754,4 +754,3 @@
 #endif /* #ifndef MACFILE_H__ */
 
 /* End of File */
-
diff --git a/drivers/staging/crystalhd/bcm_70015_regs.h b/drivers/staging/crystalhd/bcm_70015_regs.h
new file mode 100644
index 0000000..d1c094c
--- /dev/null
+++ b/drivers/staging/crystalhd/bcm_70015_regs.h
@@ -0,0 +1,1376 @@
+/***************************************************************************
+ *     Copyright (c) 1999-2009, Broadcom Corporation
+ *
+ **********************************************************************
+ * This file is part of the crystalhd device driver.
+ *
+ * This driver is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * This driver is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this driver.  If not, see <http://www.gnu.org/licenses/>.
+ **********************************************************************
+ *
+ * $brcm_Workfile: bchp_misc1.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 8:11p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:42:40 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_misc1.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 8:11p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_MISC1_H__
+#define BCHP_MISC1_H__
+
+/***************************************************************************
+ *MISC1 - Registers for DMA List Control
+ ***************************************************************************/
+#define BCHP_MISC1_TX_FIRST_DESC_L_ADDR_LIST0    0x00502000 /* Tx DMA Descriptor List0 First Descriptor lower Address */
+#define BCHP_MISC1_TX_FIRST_DESC_U_ADDR_LIST0    0x00502004 /* Tx DMA Descriptor List0 First Descriptor Upper Address */
+#define BCHP_MISC1_TX_FIRST_DESC_L_ADDR_LIST1    0x00502008 /* Tx DMA Descriptor List1 First Descriptor Lower Address */
+#define BCHP_MISC1_TX_FIRST_DESC_U_ADDR_LIST1    0x0050200c /* Tx DMA Descriptor List1 First Descriptor Upper Address */
+#define BCHP_MISC1_TX_SW_DESC_LIST_CTRL_STS      0x00502010 /* Tx DMA Software Descriptor List Control and Status */
+#define BCHP_MISC1_TX_DMA_ERROR_STATUS           0x00502018 /* Tx DMA Engine Error Status */
+#define BCHP_MISC1_TX_DMA_CTRL                   0x00502034 /* Tx DMA Flea Interface Control */
+#define BCHP_MISC1_Y_RX_SW_DESC_LIST_CTRL_STS    0x00502050 /* Y Rx Software Descriptor List Control and Status */
+#define BCHP_MISC1_Y_RX_ERROR_STATUS             0x00502054 /* Y Rx Engine Error Status */
+#define BCHP_MISC1_Y_RX_LIST0_CUR_BYTE_CNT       0x00502060 /* Y Rx List0 Current Descriptor Byte Count */
+#define BCHP_MISC1_Y_RX_LIST1_CUR_BYTE_CNT       0x0050206c /* Y Rx List1 Current Descriptor Byte Count */
+#define BCHP_MISC1_HIF_RX_ERROR_STATUS           0x00502094 /* HIF Rx Engine Error Status */
+#define BCHP_MISC1_HIF_RX_LIST0_CUR_BYTE_CNT     0x005020a0 /* HIF Rx List0 Current Descriptor Byte Count */
+#define BCHP_MISC1_HIF_RX_LIST1_CUR_BYTE_CNT     0x005020ac /* HIF Rx List1 Current Descriptor Byte Count */
+#define BCHP_MISC1_HIF_DMA_CTRL                  0x005020b0 /* HIF Rx DMA Flea Interface Control */
+#define BCHP_MISC1_DMA_DEBUG_OPTIONS_REG         0x005020c0 /* DMA Debug Options Register */
+
+/***************************************************************************
+ *TX_SW_DESC_LIST_CTRL_STS - Tx DMA Software Descriptor List Control and Status
+ ***************************************************************************/
+/* MISC1 :: TX_SW_DESC_LIST_CTRL_STS :: TX_DMA_RUN_STOP [00:00] */
+#define BCHP_MISC1_TX_SW_DESC_LIST_CTRL_STS_TX_DMA_RUN_STOP_MASK   0x00000001
+
+#endif /* #ifndef BCHP_MISC1_H__ */
+
+/**********************************************************************
+ *
+ * $brcm_Workfile: bchp_misc2.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 8:11p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:42:37 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_misc2.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 8:11p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_MISC2_H__
+#define BCHP_MISC2_H__
+
+/***************************************************************************
+ *MISC2 - Registers for Meta DMA, Direct DRAM Access, Global Controls
+ ***************************************************************************/
+#define BCHP_MISC2_DIRECT_WINDOW_CONTROL         0x00502120 /* Direct DRAM Access Window Control */
+
+/***************************************************************************
+ *DIRECT_WINDOW_CONTROL - Direct DRAM Access Window Control
+ ***************************************************************************/
+/* MISC2 :: DIRECT_WINDOW_CONTROL :: DIRECT_WINDOW_BASE_ADDR [31:16] */
+#define BCHP_MISC2_DIRECT_WINDOW_CONTROL_DIRECT_WINDOW_BASE_ADDR_MASK 0xffff0000
+
+/* MISC2 :: DIRECT_WINDOW_CONTROL :: DIRECT_WINDOW_ENABLE [00:00] */
+#define BCHP_MISC2_DIRECT_WINDOW_CONTROL_DIRECT_WINDOW_ENABLE_MASK 0x00000001
+
+#endif /* #ifndef BCHP_MISC2_H__ */
+
+/***************************************************************************
+ *
+ * $brcm_Workfile: bchp_misc3.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 8:11p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:42:19 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_misc3.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 8:11p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_MISC3_H__
+#define BCHP_MISC3_H__
+
+/***************************************************************************
+ *MISC3 - Registers for Reset, Options, DMA Checksums
+ ***************************************************************************/
+#define BCHP_MISC3_RESET_CTRL                    0x00502200 /* Reset Control Register */
+
+#endif /* #ifndef BCHP_MISC3_H__ */
+
+/***************************************************************************
+ *
+ * $brcm_Workfile: bchp_scrub_ctrl.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 8:18p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:42:19 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_scrub_ctrl.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 8:18p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_SCRUB_CTRL_H__
+#define BCHP_SCRUB_CTRL_H__
+
+/***************************************************************************
+ *SCRUB_CTRL - Scrub Control Registers
+ ***************************************************************************/
+#define BCHP_SCRUB_CTRL_SCRUB_ENABLE             0x000f6000 /* Secure Sequencer Enable */
+#define BCHP_SCRUB_CTRL_BORCH_END_ADDRESS        0x000f6004 /* ARM Bridge Out-of-Range Checker End Address */
+#define BCHP_SCRUB_CTRL_STARCH_END_ADDRESS       0x000f6008 /* Static ARCH End Address */
+#define BCHP_SCRUB_CTRL_BI_CMAC_31_0             0x000f600c /* Boot Image CMAC value[31:0] */
+#define BCHP_SCRUB_CTRL_BI_CMAC_63_32            0x000f6010 /* Boot Image CMAC value[63:32] */
+#define BCHP_SCRUB_CTRL_BI_CMAC_95_64            0x000f6014 /* Boot Image CMAC value[95:64] */
+#define BCHP_SCRUB_CTRL_BI_CMAC_127_96           0x000f6018 /* Boot Image CMAC value[127:96] */
+
+/***************************************************************************
+ *SCRUB_ENABLE - Secure Sequencer Enable
+ ***************************************************************************/
+/* SCRUB_CTRL :: SCRUB_ENABLE :: DSCRAM_EN [01:01] */
+#define BCHP_SCRUB_CTRL_SCRUB_ENABLE_DSCRAM_EN_SHIFT               1
+
+/* SCRUB_CTRL :: SCRUB_ENABLE :: SCRUB_EN [00:00] */
+#define BCHP_SCRUB_CTRL_SCRUB_ENABLE_SCRUB_EN_SHIFT                0
+
+/***************************************************************************
+ *BORCH_END_ADDRESS - ARM Bridge Out-of-Range Checker End Address
+ ***************************************************************************/
+/* SCRUB_CTRL :: BORCH_END_ADDRESS :: BORCH_END_ADDR [26:00] */
+#define BCHP_SCRUB_CTRL_BORCH_END_ADDRESS_BORCH_END_ADDR_MASK      0x07ffffff
+
+#endif /* #ifndef BCHP_SCRUB_CTRL_H__ */
+
+/***************************************************************************
+ *
+ * $brcm_Workfile: bchp_wrap_misc_intr2.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 8:23p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:43:21 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_wrap_misc_intr2.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 8:23p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_WRAP_MISC_INTR2_H__
+#define BCHP_WRAP_MISC_INTR2_H__
+
+/***************************************************************************
+ *WRAP_MISC_INTR2 - MISC block Level 2 Interrupt Controller
+ ***************************************************************************/
+#define BCHP_WRAP_MISC_INTR2_CPU_STATUS          0x000f2000 /* CPU interrupt Status Register */
+#define BCHP_WRAP_MISC_INTR2_PCI_STATUS          0x000f2018 /* PCI interrupt Status Register */
+#define BCHP_WRAP_MISC_INTR2_PCI_CLEAR           0x000f2020 /* PCI interrupt Clear Register */
+
+/***************************************************************************
+ *CPU_STATUS - CPU interrupt Status Register
+ ***************************************************************************/
+/* WRAP_MISC_INTR2 :: CPU_STATUS :: BOOT_VER_FAIL_INTR [23:23] */
+#define BCHP_WRAP_MISC_INTR2_CPU_STATUS_BOOT_VER_FAIL_INTR_SHIFT   23
+
+/* WRAP_MISC_INTR2 :: CPU_STATUS :: BOOT_VER_DONE_INTR [22:22] */
+#define BCHP_WRAP_MISC_INTR2_CPU_STATUS_BOOT_VER_DONE_INTR_SHIFT   22
+
+/* WRAP_MISC_INTR2 :: CPU_STATUS :: SCRM_KEY_DONE_INTR [19:19] */
+#define BCHP_WRAP_MISC_INTR2_CPU_STATUS_SCRM_KEY_DONE_INTR_SHIFT   19
+
+/* WRAP_MISC_INTR2 :: CPU_STATUS :: SHARF_ERR_INTR [04:04] */
+#define BCHP_WRAP_MISC_INTR2_CPU_STATUS_SHARF_ERR_INTR_SHIFT       4
+
+#endif /* #ifndef BCHP_WRAP_MISC_INTR2_H__ */
+
+/***************************************************************************
+ *
+ * $brcm_Workfile: bchp_armcr4_bridge.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 8:28p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:42:56 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_armcr4_bridge.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 8:28p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_ARMCR4_BRIDGE_H__
+#define BCHP_ARMCR4_BRIDGE_H__
+
+/***************************************************************************
+ *ARMCR4_BRIDGE - ARM Cortex R4 Bridge control registers
+ ***************************************************************************/
+#define BCHP_ARMCR4_BRIDGE_REG_CORE_REV_ID       0x000e0000 /* ARM Cortex R4 bridge revision ID */
+#define BCHP_ARMCR4_BRIDGE_REG_BRIDGE_CTL        0x000e0004 /* Bridge interface and buffer configuration
+ */
+#define BCHP_ARMCR4_BRIDGE_REG_ARM_CTL           0x000e0008 /* ARM core configuration */
+#define BCHP_ARMCR4_BRIDGE_REG_BRIDGE_STS        0x000e0014 /* Bridge interface and buffer status */
+#define BCHP_ARMCR4_BRIDGE_REG_MBOX_PCI1         0x000e0018 /* PCI mailbox #1 */
+#define BCHP_ARMCR4_BRIDGE_REG_MBOX_ARM1         0x000e001c /* ARM mailbox #1 */
+#define BCHP_ARMCR4_BRIDGE_REG_MBOX_PCI2         0x000e0020 /* PCI mailbox #2 */
+#define BCHP_ARMCR4_BRIDGE_REG_MBOX_ARM2         0x000e0024 /* ARM mailbox #2 */
+#define BCHP_ARMCR4_BRIDGE_REG_MBOX_PCI3         0x000e0028 /* PCI mailbox #3 */
+#define BCHP_ARMCR4_BRIDGE_REG_MBOX_ARM3         0x000e002c /* ARM mailbox #3 */
+#define BCHP_ARMCR4_BRIDGE_REG_MBOX_PCI4         0x000e0030 /* PCI mailbox #4 */
+#define BCHP_ARMCR4_BRIDGE_REG_MBOX_ARM4         0x000e0034 /* ARM mailbox #4 */
+#define BCHP_ARMCR4_BRIDGE_REG_SEMAPHORE_1       0x000e0038 /* CPU semaphore #1 */
+#define BCHP_ARMCR4_BRIDGE_REG_SEMAPHORE_2       0x000e003c /* CPU semaphore #2 */
+#define BCHP_ARMCR4_BRIDGE_REG_SEMAPHORE_3       0x000e0040 /* CPU semaphore #3 */
+#define BCHP_ARMCR4_BRIDGE_REG_SEMAPHORE_4       0x000e0044 /* CPU semaphore #4 */
+#define BCHP_ARMCR4_BRIDGE_REG_SCRATCH_1         0x000e0048 /* CPU scratchpad #1 */
+#define BCHP_ARMCR4_BRIDGE_REG_SCRATCH_2         0x000e004c /* CPU scratchpad #2 */
+#define BCHP_ARMCR4_BRIDGE_REG_SCRATCH_3         0x000e0050 /* CPU scratchpad #3 */
+#define BCHP_ARMCR4_BRIDGE_REG_SCRATCH_4         0x000e0054 /* CPU scratchpad #4 */
+#define BCHP_ARMCR4_BRIDGE_REG_SCRATCH_5         0x000e0058 /* CPU scratchpad #5 */
+#define BCHP_ARMCR4_BRIDGE_REG_SCRATCH_6         0x000e005c /* CPU scratchpad #6 */
+#define BCHP_ARMCR4_BRIDGE_REG_SCRATCH_7         0x000e0060 /* CPU scratchpad #7 */
+#define BCHP_ARMCR4_BRIDGE_REG_SCRATCH_8         0x000e0064 /* CPU scratchpad #8 */
+#define BCHP_ARMCR4_BRIDGE_REG_SCRATCH_9         0x000e0068 /* CPU scratchpad #9 */
+#define BCHP_ARMCR4_BRIDGE_REG_PERF_CONFIG       0x000e006c /* Performance monitor configuration */
+#define BCHP_ARMCR4_BRIDGE_REG_PERF_LIMIT        0x000e0070 /* Performance monitor count threshold */
+#define BCHP_ARMCR4_BRIDGE_REG_PERF_WR_CNT       0x000e0074 /* Counts the number of merge buffer updates (hits + misses) */
+#define BCHP_ARMCR4_BRIDGE_REG_PERF_WR_MISS      0x000e0078 /* Counts the number of merge buffer misses */
+#define BCHP_ARMCR4_BRIDGE_REG_PERF_RD_CNT       0x000e007c /* Counts the number of prefetch buffer accesses (hits + misses) */
+#define BCHP_ARMCR4_BRIDGE_REG_PERF_RD_MISS      0x000e0080 /* Counts the number of prefetch buffer misses */
+#define BCHP_ARMCR4_BRIDGE_REG_MEMORY_TM1        0x000e0084 /* ARM memory TM1 control register */
+#define BCHP_ARMCR4_BRIDGE_REG_MEMORY_TM2        0x000e0088 /* ARM memory TM2 control register */
+#define BCHP_ARMCR4_BRIDGE_REG_MEMORY_TM3        0x000e008c /* ARM memory TM3 control register */
+#define BCHP_ARMCR4_BRIDGE_REG_FIFO_STATUS       0x000e0090 /* Fifo Status */
+#define BCHP_ARMCR4_BRIDGE_REG_BORCH_STATUS      0x000e0094 /* Bridge Out-of-range Checker Status */
+#define BCHP_ARMCR4_BRIDGE_REG_MEMORY_TM4        0x000e0098 /* ARM memory TM4 control register */
+
+
+/***************************************************************************
+ *REG_BRIDGE_CTL - Bridge interface and buffer configuration
+ ***************************************************************************/
+/* ARMCR4_BRIDGE :: REG_BRIDGE_CTL :: arm_run_request [01:01] */
+#define BCHP_ARMCR4_BRIDGE_REG_BRIDGE_CTL_arm_run_request_SHIFT    1
+
+#endif /* #ifndef BCHP_ARMCR4_BRIDGE_H__ */
+
+/***************************************************************************
+ *
+ * $brcm_Workfile: bchp_intr.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 8:09p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:42:44 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_intr.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 8:09p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_INTR_H__
+#define BCHP_INTR_H__
+
+/***************************************************************************
+ *INTR - TGT L2 Interrupt Controller Registers
+ ***************************************************************************/
+#define BCHP_INTR_INTR_STATUS                    0x00500700 /* Interrupt Status Register */
+#define BCHP_INTR_INTR_CLR_REG                   0x00500708 /* Interrupt Clear Register */
+#define BCHP_INTR_INTR_MSK_SET_REG               0x00500710 /* Interrupt Mask Set Register */
+#define BCHP_INTR_INTR_MSK_CLR_REG               0x00500714 /* Interrupt Mask Clear Register */
+#define BCHP_INTR_EOI_CTRL                       0x00500718 /* End of interrupt control register */
+
+
+#endif /* #ifndef BCHP_INTR_H__ */
+
+/***************************************************************************
+ *
+ * $brcm_Workfile: bchp_pri_arb_control_regs.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 8:14p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:43:12 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_pri_arb_control_regs.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 8:14p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_PRI_ARB_CONTROL_REGS_H__
+#define BCHP_PRI_ARB_CONTROL_REGS_H__
+
+/***************************************************************************
+ *PRI_ARB_CONTROL_REGS - PRIMARY_ARB control registers
+ ***************************************************************************/
+#define BCHP_PRI_ARB_CONTROL_REGS_REFRESH_CTL_0  0x0040cb00 /* Refresh client control for ddr interface #0 */
+#define BCHP_PRI_ARB_CONTROL_REGS_MASTER_CTL     0x0040cb30 /* Master Control */
+
+/***************************************************************************
+ *REFRESH_CTL_0 - Refresh client control for ddr interface #0
+ ***************************************************************************/
+/* PRI_ARB_CONTROL_REGS :: REFRESH_CTL_0 :: enable [12:12] */
+#define BCHP_PRI_ARB_CONTROL_REGS_REFRESH_CTL_0_enable_MASK        0x00001000
+
+/***************************************************************************
+ *MASTER_CTL - Master Control
+ ***************************************************************************/
+/* PRI_ARB_CONTROL_REGS :: MASTER_CTL :: arb_disable [00:00] */
+#define BCHP_PRI_ARB_CONTROL_REGS_MASTER_CTL_arb_disable_Enable    0
+#define BCHP_PRI_ARB_CONTROL_REGS_MASTER_CTL_arb_disable_Disable   1
+
+#endif /* #ifndef BCHP_PRI_ARB_CONTROL_REGS_H__ */
+
+/***************************************************************************
+ *
+ * $brcm_Workfile: bchp_ddr23_ctl_regs_0.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 7:59p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:43:08 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_ddr23_ctl_regs_0.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 7:59p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_DDR23_CTL_REGS_0_H__
+#define BCHP_DDR23_CTL_REGS_0_H__
+
+/***************************************************************************
+ *DDR23_CTL_REGS_0 - DDR23 controller registers
+ ***************************************************************************/
+#define BCHP_DDR23_CTL_REGS_0_CTL_STATUS         0x01800004 /* DDR23 Controller status register */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS1            0x01800010 /* DDR23 Controller Configuration Set #1 */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2            0x01800014 /* DDR23 Controller Configuration Set #2 */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS3            0x01800018 /* DDR23 Controller Configuration Set #3 */
+#define BCHP_DDR23_CTL_REGS_0_REFRESH            0x0180001c /* DDR23 Controller Automated Refresh Configuration */
+#define BCHP_DDR23_CTL_REGS_0_REFRESH_CMD        0x01800020 /* Host Initiated Refresh Control */
+#define BCHP_DDR23_CTL_REGS_0_PRECHARGE_CMD      0x01800024 /* Host Initiated Precharge Control */
+#define BCHP_DDR23_CTL_REGS_0_LOAD_MODE_CMD      0x01800028 /* Host Initiated Load Mode Control */
+#define BCHP_DDR23_CTL_REGS_0_LOAD_EMODE_CMD     0x0180002c /* Host Initiated Load Extended Mode Control */
+#define BCHP_DDR23_CTL_REGS_0_LOAD_EMODE2_CMD    0x01800030 /* Host Initiated Load Extended Mode #2 Control */
+#define BCHP_DDR23_CTL_REGS_0_LOAD_EMODE3_CMD    0x01800034 /* Host Initiated Load Extended Mode #3 Control */
+#define BCHP_DDR23_CTL_REGS_0_ZQ_CALIBRATE       0x01800038 /* Host Initiated ZQ Calibration Cycle */
+#define BCHP_DDR23_CTL_REGS_0_LATENCY            0x01800040 /* DDR2 Controller Access Latency Control */
+#define BCHP_DDR23_CTL_REGS_0_SCRATCH            0x01800058 /* Scratch Register */
+#define BCHP_DDR23_CTL_REGS_0_UPDATE_VDL         0x018000f0 /* RAM Macro TM Control */
+
+/***************************************************************************
+ *CTL_STATUS - DDR23 Controller status register
+ ***************************************************************************/
+/* DDR23_CTL_REGS_0 :: CTL_STATUS :: clke [01:01] */
+#define BCHP_DDR23_CTL_REGS_0_CTL_STATUS_clke_MASK                 0x00000002
+
+/* DDR23_CTL_REGS_0 :: CTL_STATUS :: idle [00:00] */
+#define BCHP_DDR23_CTL_REGS_0_CTL_STATUS_idle_MASK                 0x00000001
+
+/***************************************************************************
+ *PARAMS1 - DDR23 Controller Configuration Set #1
+ ***************************************************************************/
+/* DDR23_CTL_REGS_0 :: PARAMS1 :: trtp [31:28] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS1_trtp_MASK                    0xf0000000
+#define BCHP_DDR23_CTL_REGS_0_PARAMS1_trtp_SHIFT                   28
+
+/* DDR23_CTL_REGS_0 :: PARAMS1 :: twl [27:24] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS1_twl_MASK                     0x0f000000
+#define BCHP_DDR23_CTL_REGS_0_PARAMS1_twl_SHIFT                    24
+
+/* DDR23_CTL_REGS_0 :: PARAMS1 :: tcas [23:20] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS1_tcas_MASK                    0x00f00000
+#define BCHP_DDR23_CTL_REGS_0_PARAMS1_tcas_SHIFT                   20
+
+/* DDR23_CTL_REGS_0 :: PARAMS1 :: twtr [19:16] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS1_twtr_MASK                    0x000f0000
+#define BCHP_DDR23_CTL_REGS_0_PARAMS1_twtr_SHIFT                   16
+
+/* DDR23_CTL_REGS_0 :: PARAMS1 :: twr [15:12] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS1_twr_MASK                     0x0000f000
+#define BCHP_DDR23_CTL_REGS_0_PARAMS1_twr_SHIFT                    12
+
+/* DDR23_CTL_REGS_0 :: PARAMS1 :: trrd [11:08] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS1_trrd_MASK                    0x00000f00
+#define BCHP_DDR23_CTL_REGS_0_PARAMS1_trrd_SHIFT                   8
+
+/* DDR23_CTL_REGS_0 :: PARAMS1 :: trp [07:04] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS1_trp_MASK                     0x000000f0
+#define BCHP_DDR23_CTL_REGS_0_PARAMS1_trp_SHIFT                    4
+
+/* DDR23_CTL_REGS_0 :: PARAMS1 :: trcd [03:00] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS1_trcd_MASK                    0x0000000f
+#define BCHP_DDR23_CTL_REGS_0_PARAMS1_trcd_SHIFT                   0
+
+/***************************************************************************
+ *PARAMS2 - DDR23 Controller Configuration Set #2
+ ***************************************************************************/
+/* DDR23_CTL_REGS_0 :: PARAMS2 :: auto_idle [31:31] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_auto_idle_MASK               0x80000000
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_auto_idle_SHIFT              31
+
+/* DDR23_CTL_REGS_0 :: PARAMS2 :: row_bits [30:30] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_row_bits_MASK                0x40000000
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_row_bits_SHIFT               30
+
+/* DDR23_CTL_REGS_0 :: PARAMS2 :: use_chr_hgt [29:29] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_use_chr_hgt_MASK             0x20000000
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_use_chr_hgt_SHIFT            29
+
+/* DDR23_CTL_REGS_0 :: PARAMS2 :: clke [28:28] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_clke_MASK                    0x10000000
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_clke_SHIFT                   28
+
+/* DDR23_CTL_REGS_0 :: PARAMS2 :: sd_col_bits [27:26] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_sd_col_bits_MASK             0x0c000000
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_sd_col_bits_SHIFT            26
+
+/* DDR23_CTL_REGS_0 :: PARAMS2 :: il_sel [25:25] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_il_sel_MASK                  0x02000000
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_il_sel_SHIFT                 25
+
+/* DDR23_CTL_REGS_0 :: PARAMS2 :: dis_itlv [24:24] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_dis_itlv_MASK                0x01000000
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_dis_itlv_SHIFT               24
+
+/* DDR23_CTL_REGS_0 :: PARAMS2 :: reserved0 [23:23] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_reserved0_MASK               0x00800000
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_reserved0_SHIFT              23
+
+/* DDR23_CTL_REGS_0 :: PARAMS2 :: cs0_only [22:22] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_cs0_only_MASK                0x00400000
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_cs0_only_SHIFT               22
+
+/* DDR23_CTL_REGS_0 :: PARAMS2 :: allow_pictmem_rd [21:21] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_allow_pictmem_rd_MASK        0x00200000
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_allow_pictmem_rd_SHIFT       21
+
+/* DDR23_CTL_REGS_0 :: PARAMS2 :: bank_bits [20:20] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_bank_bits_MASK               0x00100000
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_bank_bits_SHIFT              20
+
+/* DDR23_CTL_REGS_0 :: PARAMS2 :: trfc [19:12] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_trfc_MASK                    0x000ff000
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_trfc_SHIFT                   12
+
+/* DDR23_CTL_REGS_0 :: PARAMS2 :: tfaw [11:06] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_tfaw_MASK                    0x00000fc0
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_tfaw_SHIFT                   6
+
+/* DDR23_CTL_REGS_0 :: PARAMS2 :: tras [05:00] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_tras_MASK                    0x0000003f
+#define BCHP_DDR23_CTL_REGS_0_PARAMS2_tras_SHIFT                   0
+
+/***************************************************************************
+ *PARAMS3 - DDR23 Controller Configuration Set #3
+ ***************************************************************************/
+/* DDR23_CTL_REGS_0 :: PARAMS3 :: ddr3_reset [31:31] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS3_ddr3_reset_MASK              0x80000000
+#define BCHP_DDR23_CTL_REGS_0_PARAMS3_ddr3_reset_SHIFT             31
+
+/* DDR23_CTL_REGS_0 :: PARAMS3 :: reserved0 [30:06] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS3_reserved0_MASK               0x7fffffc0
+#define BCHP_DDR23_CTL_REGS_0_PARAMS3_reserved0_SHIFT              6
+
+/* DDR23_CTL_REGS_0 :: PARAMS3 :: ddr_bl [05:05] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS3_ddr_bl_MASK                  0x00000020
+#define BCHP_DDR23_CTL_REGS_0_PARAMS3_ddr_bl_SHIFT                 5
+
+/* DDR23_CTL_REGS_0 :: PARAMS3 :: cmd_2t [04:04] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS3_cmd_2t_MASK                  0x00000010
+#define BCHP_DDR23_CTL_REGS_0_PARAMS3_cmd_2t_SHIFT                 4
+
+/* DDR23_CTL_REGS_0 :: PARAMS3 :: wr_odt_mode [03:03] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS3_wr_odt_mode_MASK             0x00000008
+#define BCHP_DDR23_CTL_REGS_0_PARAMS3_wr_odt_mode_SHIFT            3
+
+/* DDR23_CTL_REGS_0 :: PARAMS3 :: wr_odt_te_adj [02:02] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS3_wr_odt_te_adj_MASK           0x00000004
+#define BCHP_DDR23_CTL_REGS_0_PARAMS3_wr_odt_te_adj_SHIFT          2
+
+/* DDR23_CTL_REGS_0 :: PARAMS3 :: wr_odt_le_adj [01:01] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS3_wr_odt_le_adj_MASK           0x00000002
+#define BCHP_DDR23_CTL_REGS_0_PARAMS3_wr_odt_le_adj_SHIFT          1
+
+/* DDR23_CTL_REGS_0 :: PARAMS3 :: wr_odt_en [00:00] */
+#define BCHP_DDR23_CTL_REGS_0_PARAMS3_wr_odt_en_MASK               0x00000001
+#define BCHP_DDR23_CTL_REGS_0_PARAMS3_wr_odt_en_SHIFT              0
+
+/***************************************************************************
+ *UPDATE_VDL - RAM Macro TM Control
+ ***************************************************************************/
+/* DDR23_CTL_REGS_0 :: UPDATE_VDL :: refresh [00:00] */
+#define BCHP_DDR23_CTL_REGS_0_UPDATE_VDL_refresh_MASK              0x00000001
+
+
+#endif /* #ifndef BCHP_DDR23_CTL_REGS_0_H__ */
+
+/***************************************************************************
+ *
+ * $brcm_Workfile: bchp_ddr23_phy_byte_lane_0.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 7:59p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:43:18 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_ddr23_phy_byte_lane_0.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 7:59p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_DDR23_PHY_BYTE_LANE_0_H__
+#define BCHP_DDR23_PHY_BYTE_LANE_0_H__
+
+/***************************************************************************
+ *DDR23_PHY_BYTE_LANE_0 - DDR23 DDR23 byte lane #0 control registers
+ ***************************************************************************/
+#define BCHP_DDR23_PHY_BYTE_LANE_0_VDL_CALIBRATE 0x01801204 /* Byte lane VDL calibration control register */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_VDL_STATUS    0x01801208 /* Byte lane VDL calibration status register */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_VDL_OVERRIDE_0 0x01801210 /* Read DQSP VDL static override control register */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_VDL_OVERRIDE_1 0x01801214 /* Read DQSN VDL static override control register */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_VDL_OVERRIDE_2 0x01801218 /* Read Enable VDL static override control register */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_VDL_OVERRIDE_3 0x0180121c /* Write data and mask VDL static override control register */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL  0x01801230 /* Byte Lane read channel control register */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL 0x0180123c /* Idle mode SSTL pad control register */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL 0x01801240 /* SSTL pad drive characteristics control register */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_WR_PREAMBLE_MODE 0x01801248 /* Write cycle preamble control register */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_CLOCK_REG_CONTROL 0x0180124c /* Clock Regulator control register */
+
+/***************************************************************************
+ *READ_CONTROL - Byte Lane read channel control register
+ ***************************************************************************/
+/* DDR23_PHY_BYTE_LANE_1 :: READ_CONTROL :: rd_data_dly [09:08] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_rd_data_dly_MASK   0x00000300
+#define BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_rd_data_dly_SHIFT  8
+
+/* DDR23_PHY_BYTE_LANE_1 :: READ_CONTROL :: dq_odt_enable [03:03] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_dq_odt_enable_MASK 0x00000008
+#define BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_dq_odt_enable_SHIFT 3
+
+/* DDR23_PHY_BYTE_LANE_1 :: READ_CONTROL :: dq_odt_adj [02:02] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_dq_odt_adj_MASK    0x00000004
+#define BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_dq_odt_adj_SHIFT   2
+
+/* DDR23_PHY_BYTE_LANE_1 :: READ_CONTROL :: rd_enb_odt_enable [01:01] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_rd_enb_odt_enable_MASK 0x00000002
+#define BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_rd_enb_odt_enable_SHIFT 1
+
+/* DDR23_PHY_BYTE_LANE_1 :: READ_CONTROL :: rd_enb_odt_adj [00:00] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_rd_enb_odt_adj_MASK 0x00000001
+#define BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_rd_enb_odt_adj_SHIFT 0
+
+/***************************************************************************
+ *IDLE_PAD_CONTROL - Idle mode SSTL pad control register
+ ***************************************************************************/
+/* DDR23_PHY_BYTE_LANE_1 :: IDLE_PAD_CONTROL :: idle [31:31] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_idle_MASK      0x80000000
+
+/* DDR23_PHY_BYTE_LANE_1 :: IDLE_PAD_CONTROL :: dm_iddq [18:18] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_dm_iddq_MASK   0x00040000
+
+/* DDR23_PHY_BYTE_LANE_1 :: IDLE_PAD_CONTROL :: dq_iddq [14:14] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_dq_iddq_MASK   0x00004000
+
+/* DDR23_PHY_BYTE_LANE_1 :: IDLE_PAD_CONTROL :: read_enb_iddq [10:10] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_read_enb_iddq_MASK 0x00000400
+
+/* DDR23_PHY_BYTE_LANE_1 :: IDLE_PAD_CONTROL :: dqs_iddq [06:06] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_dqs_iddq_MASK  0x00000040
+
+/* DDR23_PHY_BYTE_LANE_1 :: IDLE_PAD_CONTROL :: clk_iddq [02:02] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_clk_iddq_MASK  0x00000004
+
+/***************************************************************************
+ *DRIVE_PAD_CTL - SSTL pad drive characteristics control register
+ ***************************************************************************/
+/* DDR23_PHY_BYTE_LANE_1 :: DRIVE_PAD_CTL :: seltxdrv_ci [02:02] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL_seltxdrv_ci_MASK  0x00000004
+
+/***************************************************************************
+ *CLOCK_REG_CONTROL - Clock Regulator control register
+ ***************************************************************************/
+/* DDR23_PHY_BYTE_LANE_1 :: CLOCK_REG_CONTROL :: pwrdn [00:00] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_CLOCK_REG_CONTROL_pwrdn_MASK    0x00000001
+
+#endif /* #ifndef BCHP_DDR23_PHY_BYTE_LANE_0_H__ */
+
+/***************************************************************************
+ *
+ * $brcm_Workfile: bchp_ddr23_phy_byte_lane_1.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 7:59p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:42:17 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_ddr23_phy_byte_lane_1.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 7:59p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_DDR23_PHY_BYTE_LANE_1_H__
+#define BCHP_DDR23_PHY_BYTE_LANE_1_H__
+
+/***************************************************************************
+ *DDR23_PHY_BYTE_LANE_1 - DDR23 DDR23 byte lane #1 control registers
+ ***************************************************************************/
+#define BCHP_DDR23_PHY_BYTE_LANE_1_VDL_CALIBRATE 0x01801104 /* Byte lane VDL calibration control register */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_VDL_STATUS    0x01801108 /* Byte lane VDL calibration status register */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_VDL_OVERRIDE_0 0x01801110 /* Read DQSP VDL static override control register */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_VDL_OVERRIDE_1 0x01801114 /* Read DQSN VDL static override control register */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_VDL_OVERRIDE_2 0x01801118 /* Read Enable VDL static override control register */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_VDL_OVERRIDE_3 0x0180111c /* Write data and mask VDL static override control register */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_READ_CONTROL  0x01801130 /* Byte Lane read channel control register */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL 0x0180113c /* Idle mode SSTL pad control register */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_DRIVE_PAD_CTL 0x01801140 /* SSTL pad drive characteristics control register */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_CLOCK_PAD_DISABLE 0x01801144 /* Clock pad disable register */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_WR_PREAMBLE_MODE 0x01801148 /* Write cycle preamble control register */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_CLOCK_REG_CONTROL 0x0180114c /* Clock Regulator control register */
+
+/***************************************************************************
+ *READ_CONTROL - Byte Lane read channel control register
+ ***************************************************************************/
+/* DDR23_PHY_BYTE_LANE_1 :: READ_CONTROL :: dq_odt_enable [03:03] */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_READ_CONTROL_dq_odt_enable_MASK 0x00000008
+
+/***************************************************************************
+ *IDLE_PAD_CONTROL - Idle mode SSTL pad control register
+ ***************************************************************************/
+/* DDR23_PHY_BYTE_LANE_1 :: IDLE_PAD_CONTROL :: idle [31:31] */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_idle_MASK      0x80000000
+
+/* DDR23_PHY_BYTE_LANE_1 :: IDLE_PAD_CONTROL :: dm_iddq [18:18] */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_dm_iddq_MASK   0x00040000
+
+/* DDR23_PHY_BYTE_LANE_1 :: IDLE_PAD_CONTROL :: dq_iddq [14:14] */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_dq_iddq_MASK   0x00004000
+
+/* DDR23_PHY_BYTE_LANE_1 :: IDLE_PAD_CONTROL :: read_enb_iddq [10:10] */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_read_enb_iddq_MASK 0x00000400
+
+/* DDR23_PHY_BYTE_LANE_1 :: IDLE_PAD_CONTROL :: dqs_iddq [06:06] */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_dqs_iddq_MASK  0x00000040
+
+/* DDR23_PHY_BYTE_LANE_1 :: IDLE_PAD_CONTROL :: clk_iddq [02:02] */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_clk_iddq_MASK  0x00000004
+
+/***************************************************************************
+ *DRIVE_PAD_CTL - SSTL pad drive characteristics control register
+ ***************************************************************************/
+/* DDR23_PHY_BYTE_LANE_1 :: DRIVE_PAD_CTL :: reserved0 [31:06] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL_reserved0_MASK    0xffffffc0
+#define BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL_reserved0_SHIFT   6
+
+/* DDR23_PHY_BYTE_LANE_1 :: DRIVE_PAD_CTL :: rt60b_ddr_read_enb [05:05] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL_rt60b_ddr_read_enb_MASK 0x00000020
+#define BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL_rt60b_ddr_read_enb_SHIFT 5
+
+/* DDR23_PHY_BYTE_LANE_1 :: DRIVE_PAD_CTL :: rt60b [04:04] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL_rt60b_MASK        0x00000010
+#define BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL_rt60b_SHIFT       4
+
+/* DDR23_PHY_BYTE_LANE_1 :: DRIVE_PAD_CTL :: sel_sstl18 [03:03] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL_sel_sstl18_MASK   0x00000008
+#define BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL_sel_sstl18_SHIFT  3
+
+/* DDR23_PHY_BYTE_LANE_1 :: DRIVE_PAD_CTL :: seltxdrv_ci [02:02] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL_seltxdrv_ci_MASK  0x00000004
+#define BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL_seltxdrv_ci_SHIFT 2
+
+/* DDR23_PHY_BYTE_LANE_1 :: DRIVE_PAD_CTL :: selrxdrv [01:01] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL_selrxdrv_MASK     0x00000002
+#define BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL_selrxdrv_SHIFT    1
+
+/* DDR23_PHY_BYTE_LANE_1 :: DRIVE_PAD_CTL :: slew [00:00] */
+#define BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL_slew_MASK         0x00000001
+#define BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL_slew_SHIFT        0
+
+/***************************************************************************
+ *CLOCK_PAD_DISABLE - Clock pad disable register
+ ***************************************************************************/
+/* DDR23_PHY_BYTE_LANE_1 :: CLOCK_PAD_DISABLE :: clk_pad_dis [00:00] */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_CLOCK_PAD_DISABLE_clk_pad_dis_MASK 0x00000001
+
+/***************************************************************************
+ *CLOCK_REG_CONTROL - Clock Regulator control register
+ ***************************************************************************/
+/* DDR23_PHY_BYTE_LANE_1 :: CLOCK_REG_CONTROL :: pwrdn [00:00] */
+#define BCHP_DDR23_PHY_BYTE_LANE_1_CLOCK_REG_CONTROL_pwrdn_MASK    0x00000001
+
+#endif /* #ifndef BCHP_DDR23_PHY_BYTE_LANE_1_H__ */
+
+/***************************************************************************
+ *
+ * $brcm_Workfile: bchp_ddr23_phy_control_regs.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 7:59p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:42:21 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_ddr23_phy_control_regs.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 7:59p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_DDR23_PHY_CONTROL_REGS_H__
+#define BCHP_DDR23_PHY_CONTROL_REGS_H__
+
+/***************************************************************************
+ *DDR23_PHY_CONTROL_REGS - DDR23 DDR23 physical interface control registers
+ ***************************************************************************/
+#define BCHP_DDR23_PHY_CONTROL_REGS_CLK_PM_CTRL  0x01801004 /* PHY clock power management control register */
+#define BCHP_DDR23_PHY_CONTROL_REGS_PLL_STATUS   0x01801010 /* PHY PLL status register */
+#define BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG   0x01801014 /* PHY PLL configuration register */
+#define BCHP_DDR23_PHY_CONTROL_REGS_PLL_PRE_DIVIDER 0x01801018 /* PHY PLL pre-divider control register */
+#define BCHP_DDR23_PHY_CONTROL_REGS_PLL_DIVIDER  0x0180101c /* PHY PLL divider control register */
+#define BCHP_DDR23_PHY_CONTROL_REGS_STATIC_VDL_OVERRIDE 0x01801030 /* Address & Control VDL static override control register */
+#define BCHP_DDR23_PHY_CONTROL_REGS_IDLE_PAD_CONTROL 0x01801038 /* Idle mode SSTL pad control register */
+#define BCHP_DDR23_PHY_CONTROL_REGS_ZQ_PVT_COMP_CTL 0x0180103c /* PVT Compensation control and status register */
+#define BCHP_DDR23_PHY_CONTROL_REGS_DRIVE_PAD_CTL 0x01801040 /* SSTL pad drive characteristics control register */
+#define BCHP_DDR23_PHY_CONTROL_REGS_CLOCK_REG_CONTROL 0x01801044 /* Clock Regulator control register */
+
+/***************************************************************************
+ *CLK_PM_CTRL - PHY clock power management control register
+ ***************************************************************************/
+/* DDR23_PHY_CONTROL_REGS :: CLK_PM_CTRL :: DIS_DDR_CLK [00:00] */
+#define BCHP_DDR23_PHY_CONTROL_REGS_CLK_PM_CTRL_DIS_DDR_CLK_MASK   0x00000001
+
+/***************************************************************************
+ *PLL_CONFIG - PHY PLL configuration register
+ ***************************************************************************/
+/* DDR23_PHY_CONTROL_REGS :: PLL_CONFIG :: ENB_CLKOUT [04:04] */
+#define BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG_ENB_CLKOUT_MASK     0x00000010
+
+/* DDR23_PHY_CONTROL_REGS :: PLL_CONFIG :: PWRDN [00:00] */
+#define BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG_PWRDN_MASK          0x00000001
+
+/***************************************************************************
+ *IDLE_PAD_CONTROL - Idle mode SSTL pad control register
+ ***************************************************************************/
+/* DDR23_PHY_CONTROL_REGS :: IDLE_PAD_CONTROL :: idle [31:31] */
+#define BCHP_DDR23_PHY_CONTROL_REGS_IDLE_PAD_CONTROL_idle_MASK     0x80000000
+
+/* DDR23_PHY_CONTROL_REGS :: IDLE_PAD_CONTROL :: rxenb [08:08] */
+#define BCHP_DDR23_PHY_CONTROL_REGS_IDLE_PAD_CONTROL_rxenb_MASK    0x00000100
+
+/* DDR23_PHY_CONTROL_REGS :: IDLE_PAD_CONTROL :: ctl_iddq [06:06] */
+#define BCHP_DDR23_PHY_CONTROL_REGS_IDLE_PAD_CONTROL_ctl_iddq_MASK 0x00000040
+
+/* DDR23_PHY_CONTROL_REGS :: IDLE_PAD_CONTROL :: cke_reb [01:01] */
+#define BCHP_DDR23_PHY_CONTROL_REGS_IDLE_PAD_CONTROL_cke_reb_MASK  0x00000002
+
+/***************************************************************************
+ *DRIVE_PAD_CTL - SSTL pad drive characteristics control register
+ ***************************************************************************/
+/* DDR23_PHY_CONTROL_REGS :: DRIVE_PAD_CTL :: reserved0 [31:05] */
+#define BCHP_DDR23_PHY_CONTROL_REGS_DRIVE_PAD_CTL_reserved0_MASK   0xffffffe0
+#define BCHP_DDR23_PHY_CONTROL_REGS_DRIVE_PAD_CTL_reserved0_SHIFT  5
+
+/* DDR23_PHY_CONTROL_REGS :: DRIVE_PAD_CTL :: rt60b [04:04] */
+#define BCHP_DDR23_PHY_CONTROL_REGS_DRIVE_PAD_CTL_rt60b_MASK       0x00000010
+#define BCHP_DDR23_PHY_CONTROL_REGS_DRIVE_PAD_CTL_rt60b_SHIFT      4
+
+/* DDR23_PHY_CONTROL_REGS :: DRIVE_PAD_CTL :: sel_sstl18 [03:03] */
+#define BCHP_DDR23_PHY_CONTROL_REGS_DRIVE_PAD_CTL_sel_sstl18_MASK  0x00000008
+#define BCHP_DDR23_PHY_CONTROL_REGS_DRIVE_PAD_CTL_sel_sstl18_SHIFT 3
+
+/* DDR23_PHY_CONTROL_REGS :: DRIVE_PAD_CTL :: seltxdrv_ci [02:02] */
+#define BCHP_DDR23_PHY_CONTROL_REGS_DRIVE_PAD_CTL_seltxdrv_ci_MASK 0x00000004
+#define BCHP_DDR23_PHY_CONTROL_REGS_DRIVE_PAD_CTL_seltxdrv_ci_SHIFT 2
+
+/* DDR23_PHY_CONTROL_REGS :: DRIVE_PAD_CTL :: selrxdrv [01:01] */
+#define BCHP_DDR23_PHY_CONTROL_REGS_DRIVE_PAD_CTL_selrxdrv_MASK    0x00000002
+#define BCHP_DDR23_PHY_CONTROL_REGS_DRIVE_PAD_CTL_selrxdrv_SHIFT   1
+
+/* DDR23_PHY_CONTROL_REGS :: DRIVE_PAD_CTL :: slew [00:00] */
+#define BCHP_DDR23_PHY_CONTROL_REGS_DRIVE_PAD_CTL_slew_MASK        0x00000001
+#define BCHP_DDR23_PHY_CONTROL_REGS_DRIVE_PAD_CTL_slew_SHIFT       0
+
+/***************************************************************************
+ *ZQ_PVT_COMP_CTL - PVT Compensation control and status register
+ ***************************************************************************/
+/* DDR23_PHY_CONTROL_REGS :: ZQ_PVT_COMP_CTL :: sample_done [28:28] */
+#define BCHP_DDR23_PHY_CONTROL_REGS_ZQ_PVT_COMP_CTL_sample_done_MASK 0x10000000
+
+/* DDR23_PHY_CONTROL_REGS :: ZQ_PVT_COMP_CTL :: sample_en [26:26] */
+#define BCHP_DDR23_PHY_CONTROL_REGS_ZQ_PVT_COMP_CTL_sample_en_MASK 0x04000000
+
+/***************************************************************************
+ *CLOCK_REG_CONTROL - Clock Regulator control register
+ ***************************************************************************/
+/* DDR23_PHY_CONTROL_REGS :: CLOCK_REG_CONTROL :: pwrdn [00:00] */
+#define BCHP_DDR23_PHY_CONTROL_REGS_CLOCK_REG_CONTROL_pwrdn_MASK   0x00000001
+
+#endif /* #ifndef BCHP_DDR23_PHY_CONTROL_REGS_H__ */
+
+/***************************************************************************
+ *
+ * $brcm_Workfile: bchp_clk.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 7:58p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:42:39 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_clk.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 7:58p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_CLK_H__
+#define BCHP_CLK_H__
+
+/***************************************************************************
+ *CLK - CLOCK_GEN Registers
+ ***************************************************************************/
+#define BCHP_CLK_PM_CTRL                         0x00070004 /* Software power management control to turn off clocks */
+#define BCHP_CLK_TEMP_MON_CTRL                   0x00070040 /* Temperature monitor control. */
+#define BCHP_CLK_TEMP_MON_STATUS                 0x00070044 /* Temperature monitor status. */
+#define BCHP_CLK_PLL0_ARM_DIV                    0x00070110 /* Main PLL0 channel 3 ARM clock divider settings */
+#define BCHP_CLK_PLL1_CTRL                       0x00070120 /* Main PLL1 reset, enable, powerdown, and control */
+
+/***************************************************************************
+ *PM_CTRL - Software power management control to turn off clocks
+ ***************************************************************************/
+/* CLK :: PM_CTRL :: DIS_SUN_27_LOW_PWR [25:25] */
+#define BCHP_CLK_PM_CTRL_DIS_SUN_27_LOW_PWR_MASK                   0x02000000
+
+/* CLK :: PM_CTRL :: DIS_SUN_108_LOW_PWR [24:24] */
+#define BCHP_CLK_PM_CTRL_DIS_SUN_108_LOW_PWR_MASK                  0x01000000
+
+/* CLK :: PM_CTRL :: DIS_MISC_OTP_9_CLK [19:19] */
+#define BCHP_CLK_PM_CTRL_DIS_MISC_OTP_9_CLK_MASK                   0x00080000
+
+/* CLK :: PM_CTRL :: DIS_ARM_CLK [18:18] */
+#define BCHP_CLK_PM_CTRL_DIS_ARM_CLK_MASK                          0x00040000
+
+/* CLK :: PM_CTRL :: DIS_AVD_CLK [17:17] */
+#define BCHP_CLK_PM_CTRL_DIS_AVD_CLK_MASK                          0x00020000
+
+/* CLK :: PM_CTRL :: DIS_BLINK_108_CLK [12:12] */
+#define BCHP_CLK_PM_CTRL_DIS_BLINK_108_CLK_MASK                    0x00001000
+
+/* CLK :: PM_CTRL :: DIS_DDR_108_CLK [11:11] */
+#define BCHP_CLK_PM_CTRL_DIS_DDR_108_CLK_MASK                      0x00000800
+
+/* CLK :: PM_CTRL :: DIS_AVD_108_CLK [10:10] */
+#define BCHP_CLK_PM_CTRL_DIS_AVD_108_CLK_MASK                      0x00000400
+
+/* CLK :: PM_CTRL :: DIS_MISC_108_CLK [09:09] */
+#define BCHP_CLK_PM_CTRL_DIS_MISC_108_CLK_MASK                     0x00000200
+
+/* CLK :: PM_CTRL :: DIS_BLINK_216_CLK [04:04] */
+#define BCHP_CLK_PM_CTRL_DIS_BLINK_216_CLK_MASK                    0x00000010
+
+/* CLK :: PM_CTRL :: DIS_DDR_216_CLK [03:03] */
+#define BCHP_CLK_PM_CTRL_DIS_DDR_216_CLK_MASK                      0x00000008
+
+/* CLK :: PM_CTRL :: DIS_AVD_216_CLK [02:02] */
+#define BCHP_CLK_PM_CTRL_DIS_AVD_216_CLK_MASK                      0x00000004
+
+/* CLK :: PM_CTRL :: DIS_MISC_216_CLK [01:01] */
+#define BCHP_CLK_PM_CTRL_DIS_MISC_216_CLK_MASK                     0x00000002
+
+/* CLK :: PM_CTRL :: DIS_SUN_216_CLK [00:00] */
+#define BCHP_CLK_PM_CTRL_DIS_SUN_216_CLK_MASK                      0x00000001
+
+/***************************************************************************
+ *PLL1_CTRL - Main PLL1 reset, enable, powerdown, and control
+ ***************************************************************************/
+/* CLK :: PLL1_CTRL :: POWERDOWN [03:03] */
+#define BCHP_CLK_PLL1_CTRL_POWERDOWN_MASK                          0x00000008
+
+#endif /* #ifndef BCHP_CLK_H__ */
+
+/***************************************************************************
+ *
+ * $brcm_Workfile: bchp_pcie_tl.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 8:13p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:42:28 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_pcie_tl.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 8:13p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_PCIE_TL_H__
+#define BCHP_PCIE_TL_H__
+
+/***************************************************************************
+ *PCIE_TL - PCIE TL related registers
+ ***************************************************************************/
+#define BCHP_PCIE_TL_TRANSACTION_CONFIGURATION   0x00500404 /* TRANSACTION_CONFIGURATION Register */
+
+#endif /* #ifndef BCHP_PCIE_TL_H__ */
+
+/***************************************************************************
+ *
+ * $brcm_Workfile: bchp_sun_gisb_arb.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 8:19p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:42:30 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_sun_gisb_arb.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 8:19p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_SUN_GISB_ARB_H__
+#define BCHP_SUN_GISB_ARB_H__
+
+/***************************************************************************
+ *SUN_GISB_ARB - GISB Arbiter registers
+ ***************************************************************************/
+#define BCHP_SUN_GISB_ARB_TIMER                  0x0040000c /* GISB ARBITER Timer Value Register */
+
+#endif /* #ifndef BCHP_SUN_GISB_ARB_H__ */
+
+/***************************************************************************
+ *
+ * $brcm_Workfile: bchp_misc_perst.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 8:12p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:43:23 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_misc_perst.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 8:12p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_MISC_PERST_H__
+#define BCHP_MISC_PERST_H__
+
+/***************************************************************************
+ *MISC_PERST - Registers for Link reset on PERST_N
+ ***************************************************************************/
+#define BCHP_MISC_PERST_CLOCK_CTRL               0x0050229c /* Clock Control Register */
+
+/***************************************************************************
+ *CLOCK_CTRL - Clock Control Register
+ ***************************************************************************/
+/* MISC_PERST :: CLOCK_CTRL :: EARLY_L1_EXIT [02:02] */
+#define BCHP_MISC_PERST_CLOCK_CTRL_EARLY_L1_EXIT_MASK              0x00000004
+
+#endif /* #ifndef BCHP_MISC_PERST_H__ */
+
+/***************************************************************************
+ *
+ * $brcm_Workfile: bchp_sun_top_ctrl.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 8:20p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:43:07 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_sun_top_ctrl.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 8:20p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_SUN_TOP_CTRL_H__
+#define BCHP_SUN_TOP_CTRL_H__
+
+/***************************************************************************
+ *SUN_TOP_CTRL - Top Control registers
+ ***************************************************************************/
+#define BCHP_SUN_TOP_CTRL_PIN_MUX_CTRL_0         0x00404100 /* Pinmux control register 0 */
+
+#endif /* #ifndef BCHP_SUN_TOP_CTRL_H__ */
+
+/***************************************************************************
+ *
+ * $brcm_Workfile: bchp_gio.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 8:07p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:42:13 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_gio.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 8:07p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_GIO_H__
+#define BCHP_GIO_H__
+
+/***************************************************************************
+ *GIO - GPIO
+ ***************************************************************************/
+#define BCHP_GIO_DATA_LO                         0x00406004 /* GENERAL PURPOSE I/O DATA [31:0] */
+#define BCHP_GIO_IODIR_LO                        0x00406008 /* GENERAL PURPOSE I/O DIRECTION [31:0] */
+
+#endif /* #ifndef BCHP_GIO_H__ */
+
+/***************************************************************************
+ *
+ * $brcm_Workfile: bchp_pri_client_regs.h $
+ * $brcm_Revision: Hydra_Software_Devel/1 $
+ * $brcm_Date: 7/17/09 8:16p $
+ *
+ * Module Description:
+ *                     DO NOT EDIT THIS FILE DIRECTLY
+ *
+ * This module was generated magically with RDB from a source description
+ * file. You must edit the source file for changes to be made to this file.
+ *
+ *
+ * Date:           Generated on         Fri Jul 17 19:42:12 2009
+ *                 MD5 Checksum         2914699efc3fb3edefca5cb4f4f38b34
+ *
+ * Compiled with:  RDB Utility          combo_header.pl
+ *                 RDB Parser           3.0
+ *                 unknown              unknown
+ *                 Perl Interpreter     5.008008
+ *                 Operating System     linux
+ *
+ * Revision History:
+ *
+ * $brcm_Log: /magnum/basemodules/chp/70015/rdb/a0/bchp_pri_client_regs.h $
+ *
+ * Hydra_Software_Devel/1   7/17/09 8:16p albertl
+ * PR56880: Initial revision.
+ *
+ ***************************************************************************/
+
+#ifndef BCHP_PRI_CLIENT_REGS_H__
+#define BCHP_PRI_CLIENT_REGS_H__
+
+/***************************************************************************
+ *PRI_CLIENT_REGS - PRIMARY_ARB_CLIENTS client configuration registers
+ ***************************************************************************/
+#define BCHP_PRI_CLIENT_REGS_CLIENT_00_COUNT     0x0040c000 /* Arbiter Client DEBLOCK Blockout Counter Register */
+#define BCHP_PRI_CLIENT_REGS_CLIENT_00_CONTROL   0x0040c004 /* Arbiter Client DEBLOCK Configuration Register */
+
+#endif /* #ifndef BCHP_PRI_CLIENT_REGS_H__ */
diff --git a/drivers/staging/crystalhd/crystalhd.h b/drivers/staging/crystalhd/crystalhd.h
index b3a550b..9c54b3d 100644
--- a/drivers/staging/crystalhd/crystalhd.h
+++ b/drivers/staging/crystalhd/crystalhd.h
@@ -3,11 +3,16 @@
 
 #include "bc_dts_defs.h"
 #include "crystalhd_misc.h"
+#include "crystalhd_fw_if.h"
 #include "bc_dts_glob_lnx.h"
 #include "crystalhd_hw.h"
 #include "crystalhd_cmds.h"
 #include "crystalhd_lnx.h"
 #include "bcm_70012_regs.h"
-#include "crystalhd_fw_if.h"
+#include "crystalhd_linkfuncs.h"
+#include "crystalhd_fleafuncs.h"
+#include "crystalhd_lnx.h"
+#include "FleaDefs.h"
+#include "crystalhd_flea_ddr.h"
 
 #endif
diff --git a/drivers/staging/crystalhd/crystalhd_cmds.c b/drivers/staging/crystalhd/crystalhd_cmds.c
index 07a2f24..c189d34 100644
--- a/drivers/staging/crystalhd/crystalhd_cmds.c
+++ b/drivers/staging/crystalhd/crystalhd_cmds.c
@@ -4,7 +4,7 @@
  *  Name: crystalhd_cmds . c
  *
  *  Description:
- *		BCM70010 Linux driver user command interfaces.
+ *		BCM70012/BCM70015 Linux driver user command interfaces.
  *
  *  HISTORY:
  *
@@ -41,7 +41,7 @@ static struct crystalhd_user *bc_cproc_get_uid(struct crystalhd_cmd *ctx)
 	return user;
 }
 
-static int bc_cproc_get_user_count(struct crystalhd_cmd *ctx)
+int bc_get_userhandle_count(struct crystalhd_cmd *ctx)
 {
 	int i, count = 0;
 
@@ -53,16 +53,16 @@ static int bc_cproc_get_user_count(struct crystalhd_cmd *ctx)
 	return count;
 }
 
-static void bc_cproc_mark_pwr_state(struct crystalhd_cmd *ctx)
+static void bc_cproc_mark_pwr_state(struct crystalhd_cmd *ctx, uint32_t state)
 {
 	int i;
 
 	for (i = 0; i < BC_LINK_MAX_OPENS; i++) {
 		if (!ctx->user[i].in_use)
 			continue;
-		if (ctx->user[i].mode == DTS_DIAG_MODE ||
-		    ctx->user[i].mode == DTS_PLAYBACK_MODE) {
-			ctx->pwr_state_change = 1;
+		if ((ctx->user[i].mode & 0xFF) == DTS_DIAG_MODE ||
+		    (ctx->user[i].mode & 0xFF) == DTS_PLAYBACK_MODE) {
+			ctx->pwr_state_change = state;
 			break;
 		}
 	}
@@ -71,50 +71,60 @@ static void bc_cproc_mark_pwr_state(struct crystalhd_cmd *ctx)
 static enum BC_STATUS bc_cproc_notify_mode(struct crystalhd_cmd *ctx,
 				      struct crystalhd_ioctl_data *idata)
 {
+	struct device *dev = chddev();
 	int rc = 0, i = 0;
 
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	if (ctx->user[idata->u_id].mode != DTS_MODE_INV) {
-		BCMLOG_ERR("Close the handle first..\n");
+		dev_err(dev, "Close the handle first..\n");
 		return BC_STS_ERR_USAGE;
 	}
-	if (idata->udata.u.NotifyMode.Mode == DTS_MONITOR_MODE) {
+
+	if ((idata->udata.u.NotifyMode.Mode && 0xFF) == DTS_MONITOR_MODE) {
 		ctx->user[idata->u_id].mode = idata->udata.u.NotifyMode.Mode;
 		return BC_STS_SUCCESS;
 	}
+
 	if (ctx->state != BC_LINK_INVALID) {
-		BCMLOG_ERR("Link invalid state %d\n", ctx->state);
+		dev_err(dev, "Link invalid state notify mode %x \n",
+                                                                ctx->state);
 		return BC_STS_ERR_USAGE;
 	}
+
 	/* Check for duplicate playback sessions..*/
 	for (i = 0; i < BC_LINK_MAX_OPENS; i++) {
-		if (ctx->user[i].mode == DTS_DIAG_MODE ||
-		    ctx->user[i].mode == DTS_PLAYBACK_MODE) {
-			BCMLOG_ERR("multiple playback sessions are not supported..\n");
+		if ((ctx->user[i].mode & 0xFF) == DTS_DIAG_MODE ||
+		    (ctx->user[i].mode & 0xFF) == DTS_PLAYBACK_MODE) {
+			dev_err(dev, "multiple playback sessions are not "
+				"supported..\n");
 			return BC_STS_ERR_USAGE;
 		}
 	}
 	ctx->cin_wait_exit = 0;
+
 	ctx->user[idata->u_id].mode = idata->udata.u.NotifyMode.Mode;
+	/* Create list pools */
+	rc = crystalhd_create_elem_pool(ctx->adp, BC_LINK_ELEM_POOL_SZ);
+	if (rc)
+		return BC_STS_ERROR;
 	/* Setup mmap pool for uaddr sgl mapping..*/
 	rc = crystalhd_create_dio_pool(ctx->adp, BC_LINK_MAX_SGLS);
 	if (rc)
 		return BC_STS_ERROR;
 
 	/* Setup Hardware DMA rings */
-	return crystalhd_hw_setup_dma_rings(&ctx->hw_ctx);
+	return crystalhd_hw_setup_dma_rings(ctx->hw_ctx);
 }
 
 static enum BC_STATUS bc_cproc_get_version(struct crystalhd_cmd *ctx,
 				      struct crystalhd_ioctl_data *idata)
 {
-
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 	idata->udata.u.VerInfo.DriverMajor = crystalhd_kmod_major;
@@ -128,7 +138,7 @@ static enum BC_STATUS bc_cproc_get_hwtype(struct crystalhd_cmd *ctx,
 					struct crystalhd_ioctl_data *idata)
 {
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -147,7 +157,7 @@ static enum BC_STATUS bc_cproc_reg_rd(struct crystalhd_cmd *ctx,
 {
 	if (!ctx || !idata)
 		return BC_STS_INV_ARG;
-	idata->udata.u.regAcc.Value = bc_dec_reg_rd(ctx->adp,
+	idata->udata.u.regAcc.Value = ctx->hw_ctx->pfnReadDevRegister(ctx->adp,
 					idata->udata.u.regAcc.Offset);
 	return BC_STS_SUCCESS;
 }
@@ -158,7 +168,7 @@ static enum BC_STATUS bc_cproc_reg_wr(struct crystalhd_cmd *ctx,
 	if (!ctx || !idata)
 		return BC_STS_INV_ARG;
 
-	bc_dec_reg_wr(ctx->adp, idata->udata.u.regAcc.Offset,
+	ctx->hw_ctx->pfnWriteDevRegister(ctx->adp, idata->udata.u.regAcc.Offset,
 		      idata->udata.u.regAcc.Value);
 
 	return BC_STS_SUCCESS;
@@ -170,7 +180,7 @@ static enum BC_STATUS bc_cproc_link_reg_rd(struct crystalhd_cmd *ctx,
 	if (!ctx || !idata)
 		return BC_STS_INV_ARG;
 
-	idata->udata.u.regAcc.Value = crystalhd_reg_rd(ctx->adp,
+	idata->udata.u.regAcc.Value = ctx->hw_ctx->pfnReadFPGARegister(ctx->adp,
 					idata->udata.u.regAcc.Offset);
 	return BC_STS_SUCCESS;
 }
@@ -181,7 +191,7 @@ static enum BC_STATUS bc_cproc_link_reg_wr(struct crystalhd_cmd *ctx,
 	if (!ctx || !idata)
 		return BC_STS_INV_ARG;
 
-	crystalhd_reg_wr(ctx->adp, idata->udata.u.regAcc.Offset,
+	ctx->hw_ctx->pfnWriteFPGARegister(ctx->adp, idata->udata.u.regAcc.Offset,
 		       idata->udata.u.regAcc.Value);
 
 	return BC_STS_SUCCESS;
@@ -196,10 +206,10 @@ static enum BC_STATUS bc_cproc_mem_rd(struct crystalhd_cmd *ctx,
 		return BC_STS_INV_ARG;
 
 	if (idata->udata.u.devMem.NumDwords > (idata->add_cdata_sz / 4)) {
-		BCMLOG_ERR("insufficient buffer\n");
+		dev_err(chddev(), "insufficient buffer\n");
 		return BC_STS_INV_ARG;
 	}
-	sts = crystalhd_mem_rd(ctx->adp, idata->udata.u.devMem.StartOff,
+	sts = ctx->hw_ctx->pfnDevDRAMRead(ctx->hw_ctx, idata->udata.u.devMem.StartOff,
 			     idata->udata.u.devMem.NumDwords,
 			     (uint32_t *)idata->add_cdata);
 	return sts;
@@ -215,11 +225,11 @@ static enum BC_STATUS bc_cproc_mem_wr(struct crystalhd_cmd *ctx,
 		return BC_STS_INV_ARG;
 
 	if (idata->udata.u.devMem.NumDwords > (idata->add_cdata_sz / 4)) {
-		BCMLOG_ERR("insufficient buffer\n");
+		dev_err(chddev(), "insufficient buffer\n");
 		return BC_STS_INV_ARG;
 	}
 
-	sts = crystalhd_mem_wr(ctx->adp, idata->udata.u.devMem.StartOff,
+	sts = ctx->hw_ctx->pfnDevDRAMWrite(ctx->hw_ctx, idata->udata.u.devMem.StartOff,
 			     idata->udata.u.devMem.NumDwords,
 			     (uint32_t *)idata->add_cdata);
 	return sts;
@@ -239,8 +249,10 @@ static enum BC_STATUS bc_cproc_cfg_rd(struct crystalhd_cmd *ctx,
 	off = idata->udata.u.pciCfg.Offset;
 	len = idata->udata.u.pciCfg.Size;
 
-	if (len <= 4)
-		return crystalhd_pci_cfg_rd(ctx->adp, off, len, temp);
+	if (len <= 4) {
+		sts = crystalhd_pci_cfg_rd(ctx->adp, off, len, temp);
+		return sts;
+	}
 
 	/* Truncate to dword alignment..*/
 	len = 4;
@@ -248,7 +260,7 @@ static enum BC_STATUS bc_cproc_cfg_rd(struct crystalhd_cmd *ctx,
 	for (ix = 0; ix < cnt; ix++) {
 		sts = crystalhd_pci_cfg_rd(ctx->adp, off, len, &temp[ix]);
 		if (sts != BC_STS_SUCCESS) {
-			BCMLOG_ERR("config read : %d\n", sts);
+			dev_err(chddev(), "config read : %d\n", sts);
 			return sts;
 		}
 		off += len;
@@ -280,7 +292,7 @@ static enum BC_STATUS bc_cproc_cfg_wr(struct crystalhd_cmd *ctx,
 	for (ix = 0; ix < cnt; ix++) {
 		sts = crystalhd_pci_cfg_wr(ctx->adp, off, len, temp[ix]);
 		if (sts != BC_STS_SUCCESS) {
-			BCMLOG_ERR("config write : %d\n", sts);
+			dev_err(chddev(), "config write : %d\n", sts);
 			return sts;
 		}
 		off += len;
@@ -294,24 +306,30 @@ static enum BC_STATUS bc_cproc_download_fw(struct crystalhd_cmd *ctx,
 {
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 
+	dev_dbg(chddev(), "Downloading FW\n");
+
 	if (!ctx || !idata || !idata->add_cdata || !idata->add_cdata_sz) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
-	if (ctx->state != BC_LINK_INVALID) {
-		BCMLOG_ERR("Link invalid state %d\n", ctx->state);
+	if ((ctx->state != BC_LINK_INVALID) && (ctx->state != BC_LINK_RESUME)) {
+		dev_dbg(chddev(), "Link invalid state download fw %x \n",
+		                                                ctx->state);
 		return BC_STS_ERR_USAGE;
 	}
 
-	sts = crystalhd_download_fw(ctx->adp, (uint8_t *)idata->add_cdata,
+	sts = ctx->hw_ctx->pfnFWDwnld(ctx->hw_ctx, (uint8_t *)idata->add_cdata,
 				  idata->add_cdata_sz);
 
-	if (sts != BC_STS_SUCCESS)
-		BCMLOG_ERR("Firmware Download Failure!! - %d\n", sts);
-	else
+	if (sts != BC_STS_SUCCESS) {
+		dev_info(chddev(), "Firmware Download Failure!! - %d\n", sts);
+	} else
 		ctx->state |= BC_LINK_INIT;
 
+	ctx->pwr_state_change = BC_HW_RUNNING;
+
+	ctx->hw_ctx->FwCmdCnt = 0;
 	return sts;
 }
 
@@ -331,11 +349,12 @@ static enum BC_STATUS bc_cproc_download_fw(struct crystalhd_cmd *ctx,
 static enum BC_STATUS bc_cproc_do_fw_cmd(struct crystalhd_cmd *ctx,
 					struct crystalhd_ioctl_data *idata)
 {
+	struct device *dev = chddev();
 	enum BC_STATUS sts;
 	uint32_t *cmd;
 
 	if (!(ctx->state & BC_LINK_INIT)) {
-		BCMLOG_ERR("Link invalid state %d\n", ctx->state);
+		dev_dbg(dev, "Link invalid state do fw cmd %x \n", ctx->state);
 		return BC_STS_ERR_USAGE;
 	}
 
@@ -345,18 +364,18 @@ static enum BC_STATUS bc_cproc_do_fw_cmd(struct crystalhd_cmd *ctx,
 	if (cmd[0] == eCMD_C011_DEC_CHAN_PAUSE) {
 		if (!cmd[3]) {
 			ctx->state &= ~BC_LINK_PAUSED;
-			crystalhd_hw_unpause(&ctx->hw_ctx);
+			ctx->hw_ctx->pfnIssuePause(ctx->hw_ctx, false);
 		}
 	} else if (cmd[0] == eCMD_C011_DEC_CHAN_FLUSH) {
-		BCMLOG(BCMLOG_INFO, "Flush issued\n");
+		dev_dbg(dev, "Flush issued\n");
 		if (cmd[3])
 			ctx->cin_wait_exit = 1;
 	}
 
-	sts = crystalhd_do_fw_cmd(&ctx->hw_ctx, &idata->udata.u.fwCmd);
+	sts = ctx->hw_ctx->pfnDoFirmwareCmd(ctx->hw_ctx, &idata->udata.u.fwCmd);
 
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG(BCMLOG_INFO, "fw cmd %x failed\n", cmd[0]);
+		dev_dbg(dev, "fw cmd %x failed\n", cmd[0]);
 		return sts;
 	}
 
@@ -364,7 +383,7 @@ static enum BC_STATUS bc_cproc_do_fw_cmd(struct crystalhd_cmd *ctx,
 	if (cmd[0] == eCMD_C011_DEC_CHAN_PAUSE) {
 		if (cmd[3]) {
 			ctx->state |= BC_LINK_PAUSED;
-			crystalhd_hw_pause(&ctx->hw_ctx);
+			ctx->hw_ctx->pfnIssuePause(ctx->hw_ctx, true);
 		}
 	}
 
@@ -375,10 +394,10 @@ static void bc_proc_in_completion(struct crystalhd_dio_req *dio_hnd,
 				  wait_queue_head_t *event, enum BC_STATUS sts)
 {
 	if (!dio_hnd || !event) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
 		return;
 	}
-	if (sts == BC_STS_IO_USER_ABORT)
+	if (sts == BC_STS_IO_USER_ABORT || sts == BC_STS_PWR_MGMT)
 		return;
 
 	dio_hnd->uinfo.comp_sts = sts;
@@ -392,14 +411,14 @@ static enum BC_STATUS bc_cproc_codein_sleep(struct crystalhd_cmd *ctx)
 	int rc = 0;
 
 	if (ctx->state & BC_LINK_SUSPEND)
-		return BC_STS_IO_USER_ABORT;
+		return BC_STS_PWR_MGMT;
 
 	if (ctx->cin_wait_exit) {
 		ctx->cin_wait_exit = 0;
 		return BC_STS_CMD_CANCELLED;
 	}
 	crystalhd_create_event(&sleep_ev);
-	crystalhd_wait_on_event(&sleep_ev, 0, 100, rc, 0);
+	crystalhd_wait_on_event(&sleep_ev, 0, 100, rc, false);
 	if (rc == -EINTR)
 		return BC_STS_IO_USER_ABORT;
 
@@ -410,13 +429,14 @@ static enum BC_STATUS bc_cproc_hw_txdma(struct crystalhd_cmd *ctx,
 				   struct crystalhd_ioctl_data *idata,
 				   struct crystalhd_dio_req *dio)
 {
+	struct device *dev = chddev();
 	uint32_t tx_listid = 0;
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 	wait_queue_head_t event;
 	int rc = 0;
 
 	if (!ctx || !idata || !dio) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -424,7 +444,7 @@ static enum BC_STATUS bc_cproc_hw_txdma(struct crystalhd_cmd *ctx,
 
 	ctx->tx_list_id = 0;
 	/* msleep_interruptible(2000); */
-	sts = crystalhd_hw_post_tx(&ctx->hw_ctx, dio, bc_proc_in_completion,
+	sts = crystalhd_hw_post_tx(ctx->hw_ctx, dio, bc_proc_in_completion,
 				 &event, &tx_listid,
 				 idata->udata.u.ProcInput.Encrypted);
 
@@ -432,13 +452,13 @@ static enum BC_STATUS bc_cproc_hw_txdma(struct crystalhd_cmd *ctx,
 		sts = bc_cproc_codein_sleep(ctx);
 		if (sts != BC_STS_SUCCESS)
 			break;
-		sts = crystalhd_hw_post_tx(&ctx->hw_ctx, dio,
+		sts = crystalhd_hw_post_tx(ctx->hw_ctx, dio,
 					 bc_proc_in_completion,
 					 &event, &tx_listid,
 					 idata->udata.u.ProcInput.Encrypted);
 	}
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG(BCMLOG_DBG, "_hw_txdma returning sts:%d\n", sts);
+		dev_dbg(dev, "_hw_txdma returning sts:%d\n", sts);
 		return sts;
 	}
 	if (ctx->cin_wait_exit)
@@ -446,16 +466,18 @@ static enum BC_STATUS bc_cproc_hw_txdma(struct crystalhd_cmd *ctx,
 
 	ctx->tx_list_id = tx_listid;
 
+	dev_dbg(dev, "Sending TX\n");
+
 	/* _post() succeeded.. wait for the completion. */
-	crystalhd_wait_on_event(&event, (dio->uinfo.ev_sts), 3000, rc, 0);
+	crystalhd_wait_on_event(&event, (dio->uinfo.ev_sts), 3000, rc, false);
 	ctx->tx_list_id = 0;
 	if (!rc) {
 		return dio->uinfo.comp_sts;
 	} else if (rc == -EBUSY) {
-		BCMLOG(BCMLOG_DBG, "_tx_post() T/O\n");
+		dev_dbg(dev, "_tx_post() T/O\n");
 		sts = BC_STS_TIMEOUT;
 	} else if (rc == -EINTR) {
-		BCMLOG(BCMLOG_DBG, "Tx Wait Signal int.\n");
+		dev_dbg(dev, "Tx Wait Signal int.\n");
 		sts = BC_STS_IO_USER_ABORT;
 	} else {
 		sts = BC_STS_IO_ERROR;
@@ -465,7 +487,7 @@ static enum BC_STATUS bc_cproc_hw_txdma(struct crystalhd_cmd *ctx,
 	 * so no need to wait on the event again.. the return itself
 	 * ensures the release of our resources.
 	 */
-	crystalhd_hw_cancel_tx(&ctx->hw_ctx, tx_listid);
+	crystalhd_hw_cancel_tx(ctx->hw_ctx, tx_listid);
 
 	return sts;
 }
@@ -474,29 +496,30 @@ static enum BC_STATUS bc_cproc_hw_txdma(struct crystalhd_cmd *ctx,
 static enum BC_STATUS bc_cproc_check_inbuffs(bool pin, void *ubuff,
 				 uint32_t ub_sz, uint32_t uv_off, bool en_422)
 {
+	struct device *dev = chddev();
 	if (!ubuff || !ub_sz) {
-		BCMLOG_ERR("%s->Invalid Arg %p %x\n",
+		dev_err(dev, "%s->Invalid Arg %p %x\n",
 			((pin) ? "TX" : "RX"), ubuff, ub_sz);
 		return BC_STS_INV_ARG;
 	}
 
 	/* Check for alignment */
 	if (((uintptr_t)ubuff) & 0x03) {
-		BCMLOG_ERR(
-			"%s-->Un-aligned address not implemented yet.. %p\n",
-			 ((pin) ? "TX" : "RX"), ubuff);
+		dev_err(dev,
+		        "%s-->Un-aligned address not implemented yet.. %p \n",
+				((pin) ? "TX" : "RX"), ubuff);
 		return BC_STS_NOT_IMPL;
 	}
 	if (pin)
 		return BC_STS_SUCCESS;
 
 	if (!en_422 && !uv_off) {
-		BCMLOG_ERR("Need UV offset for 420 mode.\n");
+		dev_err(dev, "Need UV offset for 420 mode.\n");
 		return BC_STS_INV_ARG;
 	}
 
 	if (en_422 && uv_off) {
-		BCMLOG_ERR("UV offset in 422 mode ??\n");
+		dev_err(dev, "UV offset in 422 mode ??\n");
 		return BC_STS_INV_ARG;
 	}
 
@@ -506,16 +529,22 @@ static enum BC_STATUS bc_cproc_check_inbuffs(bool pin, void *ubuff,
 static enum BC_STATUS bc_cproc_proc_input(struct crystalhd_cmd *ctx,
 					struct crystalhd_ioctl_data *idata)
 {
+	struct device *dev = chddev();
 	void *ubuff;
 	uint32_t ub_sz;
 	struct crystalhd_dio_req *dio_hnd = NULL;
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
+	if (ctx->state & BC_LINK_SUSPEND) {
+		dev_err(dev, "proc_input: Link Suspended\n");
+		return BC_STS_PWR_MGMT;
+	}
+
 	ubuff = idata->udata.u.ProcInput.pDmaBuff;
 	ub_sz = idata->udata.u.ProcInput.BuffSz;
 
@@ -525,7 +554,7 @@ static enum BC_STATUS bc_cproc_proc_input(struct crystalhd_cmd *ctx,
 
 	sts = crystalhd_map_dio(ctx->adp, ubuff, ub_sz, 0, 0, 1, &dio_hnd);
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("dio map - %d\n", sts);
+		dev_err(dev, "dio map - %d \n", sts);
 		return sts;
 	}
 
@@ -542,6 +571,7 @@ static enum BC_STATUS bc_cproc_proc_input(struct crystalhd_cmd *ctx,
 static enum BC_STATUS bc_cproc_add_cap_buff(struct crystalhd_cmd *ctx,
 				       struct crystalhd_ioctl_data *idata)
 {
+	struct device *dev = chddev();
 	void *ubuff;
 	uint32_t ub_sz, uv_off;
 	bool en_422;
@@ -549,7 +579,7 @@ static enum BC_STATUS bc_cproc_add_cap_buff(struct crystalhd_cmd *ctx,
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -559,20 +589,21 @@ static enum BC_STATUS bc_cproc_add_cap_buff(struct crystalhd_cmd *ctx,
 	en_422 = idata->udata.u.RxBuffs.b422Mode;
 
 	sts = bc_cproc_check_inbuffs(0, ubuff, ub_sz, uv_off, en_422);
+
 	if (sts != BC_STS_SUCCESS)
 		return sts;
 
 	sts = crystalhd_map_dio(ctx->adp, ubuff, ub_sz, uv_off,
 			      en_422, 0, &dio_hnd);
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("dio map - %d\n", sts);
+		dev_err(dev, "dio map - %d \n", sts);
 		return sts;
 	}
 
 	if (!dio_hnd)
 		return BC_STS_ERROR;
 
-	sts = crystalhd_hw_add_cap_buffer(&ctx->hw_ctx, dio_hnd,
+	sts = crystalhd_hw_add_cap_buffer(ctx->hw_ctx, dio_hnd,
 					 (ctx->state == BC_LINK_READY));
 	if ((sts != BC_STS_SUCCESS) && (sts != BC_STS_BUSY)) {
 		crystalhd_unmap_dio(ctx->adp, dio_hnd);
@@ -587,13 +618,13 @@ static enum BC_STATUS bc_cproc_fmt_change(struct crystalhd_cmd *ctx,
 {
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 
-	sts = crystalhd_hw_add_cap_buffer(&ctx->hw_ctx, dio, 0);
+	sts = crystalhd_hw_add_cap_buffer(ctx->hw_ctx, dio, 0);
 	if (sts != BC_STS_SUCCESS)
 		return sts;
 
 	ctx->state |= BC_LINK_FMT_CHG;
 	if (ctx->state == BC_LINK_READY)
-		sts = crystalhd_hw_start_capture(&ctx->hw_ctx);
+		sts = crystalhd_hw_start_capture(ctx->hw_ctx);
 
 	return sts;
 }
@@ -601,26 +632,31 @@ static enum BC_STATUS bc_cproc_fmt_change(struct crystalhd_cmd *ctx,
 static enum BC_STATUS bc_cproc_fetch_frame(struct crystalhd_cmd *ctx,
 				      struct crystalhd_ioctl_data *idata)
 {
+	struct device *dev = chddev();
 	struct crystalhd_dio_req *dio = NULL;
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 	struct BC_DEC_OUT_BUFF *frame;
 
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
+	if (ctx->state & BC_LINK_SUSPEND)
+		return BC_STS_PWR_MGMT;
+
 	if (!(ctx->state & BC_LINK_CAP_EN)) {
-		BCMLOG(BCMLOG_DBG, "Capture not enabled..%x\n", ctx->state);
+		dev_dbg(dev, "Capture not enabled..%x\n", ctx->state);
 		return BC_STS_ERR_USAGE;
 	}
 
 	frame = &idata->udata.u.DecOutData;
 
-	sts = crystalhd_hw_get_cap_buffer(&ctx->hw_ctx, &frame->PibInfo, &dio);
+	sts = crystalhd_hw_get_cap_buffer(ctx->hw_ctx, &frame->PibInfo, &dio);
 	if (sts != BC_STS_SUCCESS)
-		return (ctx->state & BC_LINK_SUSPEND) ?
-					 BC_STS_IO_USER_ABORT : sts;
+		return (ctx->state & BC_LINK_SUSPEND) ? BC_STS_PWR_MGMT : sts;
+
+	dev_dbg(dev, "Got Picture\n");
 
 	frame->Flags = dio->uinfo.comp_flags;
 
@@ -644,8 +680,27 @@ static enum BC_STATUS bc_cproc_start_capture(struct crystalhd_cmd *ctx,
 					struct crystalhd_ioctl_data *idata)
 {
 	ctx->state |= BC_LINK_CAP_EN;
+
+	if( idata->udata.u.RxCap.PauseThsh )
+		ctx->hw_ctx->PauseThreshold = idata->udata.u.RxCap.PauseThsh;
+	else
+		ctx->hw_ctx->PauseThreshold = HW_PAUSE_THRESHOLD;
+
+	if( idata->udata.u.RxCap.ResumeThsh )
+		ctx->hw_ctx->ResumeThreshold = idata->udata.u.RxCap.ResumeThsh;
+	else
+		ctx->hw_ctx->ResumeThreshold = HW_RESUME_THRESHOLD;
+
+	printk(KERN_DEBUG "start_capture: pause_th:%d, resume_th:%d\n", ctx->hw_ctx->PauseThreshold, ctx->hw_ctx->ResumeThreshold);
+
+	ctx->hw_ctx->DrvTotalFrmCaptured = 0;
+
+	ctx->hw_ctx->DefaultPauseThreshold = ctx->hw_ctx->PauseThreshold; /* used to restore on FMTCH */
+
+	ctx->hw_ctx->pfnNotifyHardware(ctx->hw_ctx, BC_EVENT_START_CAPTURE);
+
 	if (ctx->state == BC_LINK_READY)
-		return crystalhd_hw_start_capture(&ctx->hw_ctx);
+		return crystalhd_hw_start_capture(ctx->hw_ctx);
 
 	return BC_STS_SUCCESS;
 }
@@ -653,13 +708,11 @@ static enum BC_STATUS bc_cproc_start_capture(struct crystalhd_cmd *ctx,
 static enum BC_STATUS bc_cproc_flush_cap_buffs(struct crystalhd_cmd *ctx,
 					  struct crystalhd_ioctl_data *idata)
 {
-	struct crystalhd_dio_req *dio = NULL;
-	enum BC_STATUS sts = BC_STS_SUCCESS;
-	struct BC_DEC_OUT_BUFF *frame;
-	uint32_t count;
+	struct device *dev = chddev();
+	struct crystalhd_rx_dma_pkt *rpkt;
 
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -667,23 +720,25 @@ static enum BC_STATUS bc_cproc_flush_cap_buffs(struct crystalhd_cmd *ctx,
 		return BC_STS_ERR_USAGE;
 
 	/* We should ack flush even when we are in paused/suspend state */
-	if (!(ctx->state & BC_LINK_READY))
-		return crystalhd_hw_stop_capture(&ctx->hw_ctx);
-
-	ctx->state &= ~(BC_LINK_CAP_EN|BC_LINK_FMT_CHG);
-
-	frame = &idata->udata.u.DecOutData;
-	for (count = 0; count < BC_RX_LIST_CNT; count++) {
-
-		sts = crystalhd_hw_get_cap_buffer(&ctx->hw_ctx,
-					 &frame->PibInfo, &dio);
-		if (sts != BC_STS_SUCCESS)
-			break;
-
-		crystalhd_unmap_dio(ctx->adp, dio);
+/*	if (!(ctx->state & BC_LINK_READY)) */
+/*		return crystalhd_hw_stop_capture(&ctx->hw_ctx); */
+
+	dev_dbg(dev, "number of rx success %u and failure %u\n", ctx->hw_ctx->stats.rx_success, ctx->hw_ctx->stats.rx_errors);
+	if(idata->udata.u.FlushRxCap.bDiscardOnly) {
+		/* just flush without unmapping and then resume */
+		crystalhd_hw_stop_capture(ctx->hw_ctx, false);
+		while((rpkt = crystalhd_dioq_fetch(ctx->hw_ctx->rx_actq)) != NULL)
+			crystalhd_dioq_add(ctx->hw_ctx->rx_freeq, rpkt, false, rpkt->pkt_tag);
+
+		while((rpkt = crystalhd_dioq_fetch(ctx->hw_ctx->rx_rdyq)) != NULL)
+			crystalhd_dioq_add(ctx->hw_ctx->rx_freeq, rpkt, false, rpkt->pkt_tag);
+		crystalhd_hw_start_capture(ctx->hw_ctx);
+	} else {
+		ctx->state &= ~(BC_LINK_CAP_EN|BC_LINK_FMT_CHG);
+		crystalhd_hw_stop_capture(ctx->hw_ctx, true);
 	}
 
-	return crystalhd_hw_stop_capture(&ctx->hw_ctx);
+	return BC_STS_SUCCESS;
 }
 
 static enum BC_STATUS bc_cproc_get_stats(struct crystalhd_cmd *ctx,
@@ -691,13 +746,17 @@ static enum BC_STATUS bc_cproc_get_stats(struct crystalhd_cmd *ctx,
 {
 	struct BC_DTS_STATS *stats;
 	struct crystalhd_hw_stats	hw_stats;
+	uint32_t pic_width;
+	uint8_t flags = 0;
+	bool readTxOnly = false;
+	unsigned long irqflags;
 
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		dev_err(chddev(), "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
-	crystalhd_hw_stats(&ctx->hw_ctx, &hw_stats);
+	crystalhd_hw_stats(ctx->hw_ctx, &hw_stats);
 
 	stats = &idata->udata.u.drvStat;
 	stats->drvRLL = hw_stats.rdyq_count;
@@ -710,47 +769,136 @@ static enum BC_STATUS bc_cproc_get_stats(struct crystalhd_cmd *ctx,
 	stats->TxFifoBsyCnt = hw_stats.cin_busy;
 	stats->pauseCount = hw_stats.pause_cnt;
 
-	if (ctx->pwr_state_change)
-		stats->pwr_state_change = 1;
+	/* Indicate that we are checking stats on the input buffer for a single threaded application */
+	/* this will prevent the HW from going to low power because we assume that once we have told the application */
+	/* that we have space in the HW, the app is going to try to DMA. And if we block that DMA, a single threaded application */
+	/* will deadlock */
+	if(stats->DrvNextMDataPLD & BC_BIT(31))
+	{
+		flags |= 0x08;
+		/* Also for single threaded applications, check to see if we have reduced the power down */
+		/* pause threshold to too low and increase it if the RLL is close to the threshold */
+/*		if(pDrvStat->drvRLL >= pDevExt->pHwExten->PauseThreshold)
+			pDevExt->pHwExten->PauseThreshold++;
+		PeekNextTS = TRUE;*/
+	}
+
+	/* also indicate that we are just checking stats and not posting */
+	/* This allows multi-threaded applications to be placed into low power state */
+	/* because eveentually the RX thread will wake up the HW when needed */
+	flags |= 0x04;
+
+	stats->pwr_state_change = ctx->pwr_state_change;
+
 	if (ctx->state & BC_LINK_PAUSED)
 		stats->DrvPauseTime = 1;
 
+	/* use bit 29 of the input status to indicate that we are trying to read VC1 status */
+	/* This is important for the BCM70012 which uses a different input queue for VC1 */
+	if(stats->DrvcpbEmptySize & BC_BIT(29))
+		flags = 0x2;
+	/* Bit 30 is used to indicate that we are reading only the TX stats and to not touch the Ready list */
+	if(stats->DrvcpbEmptySize & BC_BIT(30))
+		readTxOnly = true;
+
+	spin_lock_irqsave(&ctx->hw_ctx->lock, irqflags);
+	ctx->hw_ctx->pfnCheckInputFIFO(ctx->hw_ctx, 0, &stats->DrvcpbEmptySize,
+				      false, &flags);
+	spin_unlock_irqrestore(&ctx->hw_ctx->lock, irqflags);
+
+	/* status peek ahead to retreive the next decoded frame timestamp */
+/*	if (!readTxOnly && stats->drvRLL && (stats->DrvNextMDataPLD & BC_BIT(31))) { */
+	if (!readTxOnly && stats->drvRLL) {
+		dev_dbg(chddev(), "Have Pictures %d\n", stats->drvRLL);
+		pic_width = stats->DrvNextMDataPLD & 0xffff;
+		stats->DrvNextMDataPLD = 0;
+		if (pic_width <= 1920) {
+			/* get fetch lock to make sure that fetch is not in progress as wel peek */
+			if(down_interruptible(&ctx->hw_ctx->fetch_sem))
+				goto get_out;
+			if(ctx->hw_ctx->pfnPeekNextDeodedFr(ctx->hw_ctx,&stats->DrvNextMDataPLD, &stats->picNumFlags, pic_width)) {
+				/* Check in case we dropped a picture here */
+				crystalhd_hw_stats(ctx->hw_ctx, &hw_stats);
+				stats->drvRLL = hw_stats.rdyq_count;
+				stats->drvFLL = hw_stats.freeq_count;
+			}
+			up(&ctx->hw_ctx->fetch_sem);
+			dev_dbg(chddev(), "peeking done\n");
+		}
+	}
+
+get_out:
 	return BC_STS_SUCCESS;
 }
 
 static enum BC_STATUS bc_cproc_reset_stats(struct crystalhd_cmd *ctx,
 				      struct crystalhd_ioctl_data *idata)
 {
-	crystalhd_hw_stats(&ctx->hw_ctx, NULL);
+	crystalhd_hw_stats(ctx->hw_ctx, NULL);
 
 	return BC_STS_SUCCESS;
 }
 
-static enum BC_STATUS bc_cproc_chg_clk(struct crystalhd_cmd *ctx,
-				  struct crystalhd_ioctl_data *idata)
+/**
+ *
+ * bc_cproc_release_user - Close Application Handle
+ *
+ * Used to be crystalhd_user_close
+ *
+ * @ctx: Command layer contextx.
+ * @uc: User ID context.
+ *
+ * Return:
+ *	status
+ *
+ * Closer aplication handle and release app specific
+ * resources.
+ *
+ * Move to IOCTL based implementation called from the RELEASE IOCTL
+ */
+enum BC_STATUS bc_cproc_release_user(struct crystalhd_cmd *ctx, struct crystalhd_ioctl_data *idata)
 {
-	struct BC_CLOCK *clock;
-	uint32_t oldClk;
-	enum BC_STATUS sts = BC_STS_SUCCESS;
+
+	struct device *dev = chddev();
+	uint32_t mode;
 
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		dev_err(dev, "%s: Invalid Arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
-	clock = &idata->udata.u.clockValue;
-	oldClk = ctx->hw_ctx.core_clock_mhz;
-	ctx->hw_ctx.core_clock_mhz = clock->clk;
+	if (ctx->user[idata->u_id].mode == DTS_MODE_INV) {
+		dev_err(dev, "Handle is already closed\n");
+		return BC_STS_ERR_USAGE;
+	}
+
+	mode = ctx->user[idata->u_id].mode;
 
-	if (ctx->state & BC_LINK_READY) {
-		sts = crystalhd_hw_set_core_clock(&ctx->hw_ctx);
-		if (sts == BC_STS_CLK_NOCHG)
-			ctx->hw_ctx.core_clock_mhz = oldClk;
+	ctx->user[idata->u_id].mode = DTS_MODE_INV;
+	ctx->user[idata->u_id].in_use = 0;
+
+	dev_info(chddev(), "Closing user[%x] handle via ioctl with mode %x\n", idata->u_id, mode);
+
+	if (((mode & 0xFF) == DTS_DIAG_MODE) ||
+		((mode & 0xFF) == DTS_PLAYBACK_MODE) ||
+		((bc_get_userhandle_count(ctx) == 0) && (ctx->hw_ctx != NULL))) {
+		ctx->cin_wait_exit = 1;
+		/* Stop the HW Capture just in case flush did not get called before stop */
+		ctx->pwr_state_change = BC_HW_RUNNING;
+		crystalhd_hw_stop_capture(ctx->hw_ctx, true);
+		crystalhd_hw_free_dma_rings(ctx->hw_ctx);
+		crystalhd_destroy_dio_pool(ctx->adp);
+		crystalhd_delete_elem_pool(ctx->adp);
+		ctx->state = BC_LINK_INVALID;
+		crystalhd_hw_close(ctx->hw_ctx, ctx->adp);
+		kfree(ctx->hw_ctx);
+		ctx->hw_ctx = NULL;
 	}
 
-	clock->clk = ctx->hw_ctx.core_clock_mhz;
+	if(ctx->adp->cfg_users > 0)
+		ctx->adp->cfg_users--;
 
-	return sts;
+	return BC_STS_SUCCESS;
 }
 
 /*=============== Cmd Proc Table.. ======================================*/
@@ -775,12 +923,11 @@ static const struct crystalhd_cmd_tbl	g_crystalhd_cproc_tbl[] = {
 	{ BCM_IOC_GET_DRV_STAT,		bc_cproc_get_stats,	0},
 	{ BCM_IOC_RST_DRV_STAT,		bc_cproc_reset_stats,	0},
 	{ BCM_IOC_NOTIFY_MODE,		bc_cproc_notify_mode,	0},
-	{ BCM_IOC_CHG_CLK,		bc_cproc_chg_clk, 0},
+	{ BCM_IOC_RELEASE,		bc_cproc_release_user,  0},
 	{ BCM_IOC_END,			NULL},
 };
 
 /*=============== Cmd Proc Functions.. ===================================*/
-
 /**
  * crystalhd_suspend - Power management suspend request.
  * @ctx: Command layer context.
@@ -804,10 +951,12 @@ static const struct crystalhd_cmd_tbl	g_crystalhd_cproc_tbl[] = {
 enum BC_STATUS crystalhd_suspend(struct crystalhd_cmd *ctx,
 				struct crystalhd_ioctl_data *idata)
 {
+	struct device *dev = chddev();
 	enum BC_STATUS sts = BC_STS_SUCCESS;
+	struct crystalhd_rx_dma_pkt *rpkt = NULL;
 
 	if (!ctx || !idata) {
-		BCMLOG_ERR("Invalid Parameters\n");
+		dev_err(dev, "Invalid Parameters\n");
 		return BC_STS_ERROR;
 	}
 
@@ -815,31 +964,42 @@ enum BC_STATUS crystalhd_suspend(struct crystalhd_cmd *ctx,
 		return BC_STS_SUCCESS;
 
 	if (ctx->state == BC_LINK_INVALID) {
-		BCMLOG(BCMLOG_DBG, "Nothing To Do Suspend Success\n");
+		dev_dbg(dev, "Nothing To Do Suspend Success\n");
 		return BC_STS_SUCCESS;
 	}
 
-	ctx->state |= BC_LINK_SUSPEND;
+	dev_dbg(dev, "State before suspend is %x\n", ctx->state);
 
-	bc_cproc_mark_pwr_state(ctx);
+	bc_cproc_mark_pwr_state(ctx, BC_HW_SUSPEND); /* going to suspend */
 
 	if (ctx->state & BC_LINK_CAP_EN) {
-		sts = bc_cproc_flush_cap_buffs(ctx, idata);
-		if (sts != BC_STS_SUCCESS)
-			return sts;
+		// Clean any pending RX
+		crystalhd_hw_stop_capture(ctx->hw_ctx, false);
+		while((rpkt = crystalhd_dioq_fetch(ctx->hw_ctx->rx_actq)) != NULL)
+			crystalhd_dioq_add(ctx->hw_ctx->rx_freeq, rpkt, false, rpkt->pkt_tag);
+
+		while((rpkt = crystalhd_dioq_fetch(ctx->hw_ctx->rx_rdyq)) != NULL)
+			crystalhd_dioq_add(ctx->hw_ctx->rx_freeq, rpkt, false, rpkt->pkt_tag);
 	}
 
 	if (ctx->tx_list_id) {
-		sts = crystalhd_hw_cancel_tx(&ctx->hw_ctx, ctx->tx_list_id);
+		sts = crystalhd_hw_cancel_tx(ctx->hw_ctx, ctx->tx_list_id);
 		if (sts != BC_STS_SUCCESS)
 			return sts;
 	}
+	else
+	{
+		// Even if there is no active TX DMA need to stop and reset TX DMA pointers
+		ctx->hw_ctx->pfnStopTxDMA(ctx->hw_ctx);
+	}
+
+	ctx->state = BC_LINK_SUSPEND;
 
-	sts = crystalhd_hw_suspend(&ctx->hw_ctx);
+	sts = crystalhd_hw_suspend(ctx->hw_ctx);
 	if (sts != BC_STS_SUCCESS)
 		return sts;
 
-	BCMLOG(BCMLOG_DBG, "BCM70012 suspend success\n");
+	dev_dbg(dev, "Crystal HD suspend success\n");
 
 	return BC_STS_SUCCESS;
 }
@@ -862,9 +1022,17 @@ enum BC_STATUS crystalhd_suspend(struct crystalhd_cmd *ctx,
  */
 enum BC_STATUS crystalhd_resume(struct crystalhd_cmd *ctx)
 {
-	BCMLOG(BCMLOG_DBG, "crystalhd_resume Success %x\n", ctx->state);
+	enum BC_STATUS sts = BC_STS_SUCCESS;
+
+	sts = crystalhd_hw_resume(ctx->hw_ctx);
+	if (sts != BC_STS_SUCCESS)
+		return sts;
+
+	bc_cproc_mark_pwr_state(ctx, BC_HW_RESUME); /* Starting resume */
 
-	bc_cproc_mark_pwr_state(ctx);
+	ctx->state = BC_LINK_RESUME;
+
+	dev_dbg(chddev(), "crystalhd_resume Success %x\n", ctx->state);
 
 	return BC_STS_SUCCESS;
 }
@@ -882,65 +1050,42 @@ enum BC_STATUS crystalhd_resume(struct crystalhd_cmd *ctx)
  * is done for the first open request.
  */
 enum BC_STATUS crystalhd_user_open(struct crystalhd_cmd *ctx,
-			    struct crystalhd_user **user_ctx)
+			      struct crystalhd_user **user_ctx)
 {
+	struct device *dev = chddev();
 	struct crystalhd_user *uc;
 
 	if (!ctx || !user_ctx) {
-		BCMLOG_ERR("Invalid arg..\n");
+		dev_err(dev, "Invalid arg..\n");
 		return BC_STS_INV_ARG;
 	}
 
 	uc = bc_cproc_get_uid(ctx);
 	if (!uc) {
-		BCMLOG(BCMLOG_INFO, "No free user context...\n");
+		dev_info(dev, "No free user context...\n");
 		return BC_STS_BUSY;
 	}
 
-	BCMLOG(BCMLOG_INFO, "Opening new user[%x] handle\n", uc->uid);
-
-	crystalhd_hw_open(&ctx->hw_ctx, ctx->adp);
-
-	uc->in_use = 1;
+	dev_info(dev, "Opening new user[%x] handle\n", uc->uid);
 
-	*user_ctx = uc;
+	uc->mode = DTS_MODE_INV;
+	uc->in_use = 0;
 
-	return BC_STS_SUCCESS;
-}
+	if(ctx->hw_ctx == NULL) {
+		ctx->hw_ctx = (struct crystalhd_hw*)kmalloc(sizeof(struct crystalhd_hw), GFP_KERNEL);
+		if(ctx->hw_ctx != NULL)
+			memset(ctx->hw_ctx, 0, sizeof(struct crystalhd_hw));
+		else
+			return BC_STS_ERROR;
 
-/**
- * crystalhd_user_close - Close application handle.
- * @ctx: Command layer contextx.
- * @uc: User ID context.
- *
- * Return:
- *	status
- *
- * Closer application handle and release app specific
- * resources.
- */
-enum BC_STATUS crystalhd_user_close(struct crystalhd_cmd *ctx,
-					 struct crystalhd_user *uc)
-{
-	uint32_t mode = uc->mode;
-
-	ctx->user[uc->uid].mode = DTS_MODE_INV;
-	ctx->user[uc->uid].in_use = 0;
-	ctx->cin_wait_exit = 1;
-	ctx->pwr_state_change = 0;
-
-	BCMLOG(BCMLOG_INFO, "Closing user[%x] handle\n", uc->uid);
-
-	if ((mode == DTS_DIAG_MODE) || (mode == DTS_PLAYBACK_MODE)) {
-		crystalhd_hw_free_dma_rings(&ctx->hw_ctx);
-		crystalhd_destroy_dio_pool(ctx->adp);
-	} else if (bc_cproc_get_user_count(ctx)) {
-		return BC_STS_SUCCESS;
+		crystalhd_hw_open(ctx->hw_ctx, ctx->adp);
 	}
 
-	crystalhd_hw_close(&ctx->hw_ctx);
+	uc->in_use = 1;
+
+	*user_ctx = uc;
 
-	ctx->state = BC_LINK_INVALID;
+	ctx->pwr_state_change = BC_HW_RUNNING;
 
 	return BC_STS_SUCCESS;
 }
@@ -958,15 +1103,16 @@ enum BC_STATUS crystalhd_user_close(struct crystalhd_cmd *ctx,
 enum BC_STATUS crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx,
 				    struct crystalhd_adp *adp)
 {
+	struct device *dev = &adp->pdev->dev;
 	int i = 0;
 
 	if (!ctx || !adp) {
-		BCMLOG_ERR("Invalid arg!!\n");
+		dev_err(dev, "%s: Invalid arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	if (ctx->adp)
-		BCMLOG(BCMLOG_DBG, "Resetting Cmd context delete missing..\n");
+		dev_dbg(dev, "Resetting Cmd context delete missing..\n");
 
 	ctx->adp = adp;
 	for (i = 0; i < BC_LINK_MAX_OPENS; i++) {
@@ -975,9 +1121,16 @@ enum BC_STATUS crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx,
 		ctx->user[i].mode = DTS_MODE_INV;
 	}
 
+	ctx->hw_ctx = (struct crystalhd_hw*)kmalloc(sizeof(struct crystalhd_hw), GFP_KERNEL);
+
+	memset(ctx->hw_ctx, 0, sizeof(struct crystalhd_hw));
+
 	/*Open and Close the Hardware to put it in to sleep state*/
-	crystalhd_hw_open(&ctx->hw_ctx, ctx->adp);
-	crystalhd_hw_close(&ctx->hw_ctx);
+	crystalhd_hw_open(ctx->hw_ctx, ctx->adp);
+	crystalhd_hw_close(ctx->hw_ctx, ctx->adp);
+	kfree(ctx->hw_ctx);
+	ctx->hw_ctx = NULL;
+
 	return BC_STS_SUCCESS;
 }
 
@@ -992,7 +1145,7 @@ enum BC_STATUS crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx,
  */
 enum BC_STATUS crystalhd_delete_cmd_context(struct crystalhd_cmd *ctx)
 {
-	BCMLOG(BCMLOG_DBG, "Deleting Command context..\n");
+	dev_dbg(chddev(), "Deleting Command context..\n");
 
 	ctx->adp = NULL;
 
@@ -1012,29 +1165,30 @@ enum BC_STATUS crystalhd_delete_cmd_context(struct crystalhd_cmd *ctx)
  * mode of operation and returns the function pointer
  * from the cproc table.
  */
-crystalhd_cmd_proc crystalhd_get_cmd_proc(struct crystalhd_cmd *ctx,
-				 uint32_t cmd, struct crystalhd_user *uc)
+crystalhd_cmd_proc crystalhd_get_cmd_proc(struct crystalhd_cmd *ctx, uint32_t cmd,
+				      struct crystalhd_user *uc)
 {
+	struct device *dev = chddev();
 	crystalhd_cmd_proc cproc = NULL;
 	unsigned int i, tbl_sz;
 
 	if (!ctx) {
-		BCMLOG_ERR("Invalid arg.. Cmd[%d]\n", cmd);
+		dev_err(dev, "Invalid arg.. Cmd[%d]\n", cmd);
 		return NULL;
 	}
 
 	if ((cmd != BCM_IOC_GET_DRV_STAT) && (ctx->state & BC_LINK_SUSPEND)) {
-		BCMLOG_ERR("Invalid State [suspend Set].. Cmd[%d]\n", cmd);
+		dev_err(dev, "Invalid State [suspend Set].. Cmd[%x]\n", cmd);
 		return NULL;
 	}
 
 	tbl_sz = sizeof(g_crystalhd_cproc_tbl) /
-				 sizeof(struct crystalhd_cmd_tbl);
+	                        sizeof(struct crystalhd_cmd_tbl);
 	for (i = 0; i < tbl_sz; i++) {
 		if (g_crystalhd_cproc_tbl[i].cmd_id == cmd) {
 			if ((uc->mode == DTS_MONITOR_MODE) &&
 			    (g_crystalhd_cproc_tbl[i].block_mon)) {
-				BCMLOG(BCMLOG_INFO, "Blocking cmd %d\n", cmd);
+				dev_dbg(dev, "Blocking cmd %d\n", cmd);
 				break;
 			}
 			cproc = g_crystalhd_cproc_tbl[i].cmd_proc;
@@ -1050,7 +1204,7 @@ crystalhd_cmd_proc crystalhd_get_cmd_proc(struct crystalhd_cmd *ctx,
  * @ctx: Command layer contextx.
  *
  * Return:
- *	TRUE: If interrupt from bcm70012 device.
+ *	TRUE: If interrupt from CrystalHD device.
  *
  *
  * ISR entry point from OS layer.
@@ -1058,9 +1212,13 @@ crystalhd_cmd_proc crystalhd_get_cmd_proc(struct crystalhd_cmd *ctx,
 bool crystalhd_cmd_interrupt(struct crystalhd_cmd *ctx)
 {
 	if (!ctx) {
-		BCMLOG_ERR("Invalid arg..\n");
-		return 0;
+		printk(KERN_ERR "%s: Invalid arg..\n", __func__);
+		return false;
 	}
 
-	return crystalhd_hw_interrupt(ctx->adp, &ctx->hw_ctx);
+	/* If HW has not been initialized then all interrupts are spurious */
+	if ((ctx->hw_ctx == NULL) || (ctx->hw_ctx->pfnFindAndClearIntr == NULL))
+		return false;
+
+	return ctx->hw_ctx->pfnFindAndClearIntr(ctx->adp, ctx->hw_ctx);
 }
diff --git a/drivers/staging/crystalhd/crystalhd_cmds.h b/drivers/staging/crystalhd/crystalhd_cmds.h
index 377cd9d..4a89270 100644
--- a/drivers/staging/crystalhd/crystalhd_cmds.h
+++ b/drivers/staging/crystalhd/crystalhd_cmds.h
@@ -36,6 +36,8 @@
 
 #include "crystalhd.h"
 
+extern struct device * chddev(void);
+
 enum crystalhd_state {
 	BC_LINK_INVALID		= 0x00,
 	BC_LINK_INIT		= 0x01,
@@ -43,6 +45,7 @@ enum crystalhd_state {
 	BC_LINK_FMT_CHG		= 0x04,
 	BC_LINK_SUSPEND		= 0x10,
 	BC_LINK_PAUSED		= 0x20,
+	BC_LINK_RESUME		= 0x40,
 	BC_LINK_READY	= (BC_LINK_INIT | BC_LINK_CAP_EN | BC_LINK_FMT_CHG),
 };
 
@@ -62,8 +65,8 @@ struct crystalhd_cmd {
 	spinlock_t		ctx_lock;
 	uint32_t		tx_list_id;
 	uint32_t		cin_wait_exit;
-	uint32_t		pwr_state_change;
-	struct crystalhd_hw	hw_ctx;
+	uint32_t		pwr_state_change; /* 0 is running, 1 is going to suspend, 2 is going to resume */
+	struct crystalhd_hw		*hw_ctx;
 };
 
 typedef enum BC_STATUS(*crystalhd_cmd_proc)(struct crystalhd_cmd *,
@@ -82,8 +85,6 @@ crystalhd_cmd_proc crystalhd_get_cmd_proc(struct crystalhd_cmd *ctx,
 				 uint32_t cmd, struct crystalhd_user *uc);
 enum BC_STATUS crystalhd_user_open(struct crystalhd_cmd *ctx,
 				 struct crystalhd_user **user_ctx);
-enum BC_STATUS crystalhd_user_close(struct crystalhd_cmd *ctx,
-				 struct crystalhd_user *uc);
 enum BC_STATUS crystalhd_setup_cmd_context(struct crystalhd_cmd *ctx,
 				 struct crystalhd_adp *adp);
 enum BC_STATUS crystalhd_delete_cmd_context(struct crystalhd_cmd *ctx);
diff --git a/drivers/staging/crystalhd/crystalhd_flea_ddr.c b/drivers/staging/crystalhd/crystalhd_flea_ddr.c
new file mode 100644
index 0000000..e222f07
--- /dev/null
+++ b/drivers/staging/crystalhd/crystalhd_flea_ddr.c
@@ -0,0 +1,735 @@
+/***************************************************************************
+ * Copyright (c) 2005-2010, Broadcom Corporation.
+ *
+ *  Name: crystalhd_flea_ddr . c
+ *
+ *  Description:
+ *		BCM70015 generic DDR routines
+ *
+ *  HISTORY:
+ *
+ **********************************************************************
+ * This file is part of the crystalhd device driver.
+ *
+ * This driver is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * This driver is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this driver.  If not, see <http://www.gnu.org/licenses/>.
+ **********************************************************************/
+
+#include "crystalhd.h"
+
+#include <linux/delay.h>
+
+/*#include "bchp_ddr23_ctl_regs_0.h" */
+/*#include "bchp_ddr23_phy_byte_lane_0.h" */
+/*#include "bchp_ddr23_phy_byte_lane_1.h" */
+/*#include "bchp_ddr23_phy_control_regs.h" */
+/*#include "bchp_pri_arb_control_regs.h" */
+/*#include "bchp_pri_client_regs.h" */
+
+/* RTS Programming Values for all Clients */
+/*   column legend */
+/*   [0]: 1=Program, 0=Default; */
+/*   [1]: Blockout Count; */
+/*   [2]: Critical Period; */
+/*   [3]: Priority; */
+/*   [4]: Access Mode */
+/* Default mode for clients is best effort */
+
+uint32_t rts_prog_vals[21][5] = {
+  {1,    130,    130,      6,      1}, /*       Deblock ( 0) */
+  {1,   1469,   1469,      9,      1}, /*         Cabac ( 1) */
+  {1,    251,    251,      4,      1}, /*         Iloop ( 2) */
+  {1,    842,    842,      5,      1}, /*         Oloop ( 3) */
+  {1,   1512,   1512,     10,      1}, /*      Symb_Int ( 4) */
+  {1,     43,     43,     14,      1}, /*         Mcomp ( 5) */
+  {1,   1318,   1318,     11,      1}, /*         XPT_0 ( 6) */
+  {1,   4320,   4320,     16,      1}, /*         XPT_1 ( 7) */
+  {1,   5400,   5400,     17,      0}, /*         XPT_2 ( 8) */
+  {1,   1080,   1080,     18,      1}, /*           ARM ( 9) */
+  {1,    691,    691,      7,      0}, /*       MEM_DMA (10) */
+  {1,   1382,   1382,     15,      0}, /*         SHARF (11) */
+  {1,    346,    346,      2,      0}, /*           BVN (12) */
+  {1,   1728,   1728,     13,      1}, /*        RxDMA3 (13) */
+  {1,    864,    864,      8,      1}, /*         TxDMA (14) */
+  {1,    173,    173,      3,      1}, /*       MetaDMA (15) */
+  {1,   2160,   2160,     19,      1}, /*     DirectDMA (16) */
+  {1,  10800,  10800,     20,      1}, /*           MSA (17) */
+  {1,    216,    216,      1,      1}, /*         TRACE (18) */
+  {1,   1598,   1598,     12,      0}, /*      refresh1 (19) */
+  { 0, 0, 0, 0, 0}, /*(20) */
+};
+
+void crystalhd_flea_ddr_pll_config(struct crystalhd_hw* hw, int32_t *speed_grade, int32_t num_plls, uint32_t tmode)
+{
+	uint32_t PLL_NDIV_INT[2];
+	uint32_t PLL_M1DIV[2];
+	int32_t  i;
+	uint32_t tmp;
+	uint32_t config;
+	uint32_t timeout;
+	uint32_t skip_init[2];     /* completely skip initialization */
+	/*uint32_t offset[2]; */
+	uint32_t skip_pll_setup;
+	uint32_t poll_cnt;
+
+	skip_init[0] =  0;
+	skip_init[1] =  0;
+
+	/* If the test mode is not 0 then skip the PLL setups too. */
+	if (tmode != 0){
+		skip_pll_setup = 1;
+	}
+	else {
+		skip_pll_setup = 0;
+	}
+
+	/* Use this scratch register in DDR0 - which should reset to 0 - as a simple symaphore for the test */
+	/* to monitor if and when the Initialization of the DDR is complete */
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_SCRATCH, 0);
+
+	if (!skip_pll_setup) {
+		for(i=0;i<num_plls;i++) {
+			switch(speed_grade[i])
+			{
+				case DDR2_333MHZ: PLL_NDIV_INT[i] = 49; PLL_M1DIV[i] = 2; break;
+				case DDR2_400MHZ: PLL_NDIV_INT[i] = 59; PLL_M1DIV[i] = 2; break;
+				case DDR2_533MHZ: PLL_NDIV_INT[i] = 39; PLL_M1DIV[i] = 1; break;
+				case DDR2_667MHZ: PLL_NDIV_INT[i] = 49; PLL_M1DIV[i] = 1; break;
+				default:
+					printk("Undefined speed_grade of %d\n",speed_grade[i]);
+					break;
+			}
+		}
+
+		/*////////////////////////// */
+		/*setup the PLLs */
+
+		for(i=0;i<num_plls;i++) {
+			if (skip_init[i]) continue;
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG,
+					  (0 << 0) | /*PWRDWN */
+					  (0 << 1) | /*REFCOMP_PWRDWN */
+					  (1 << 2) | /*ARESET */
+					  (1 << 3) | /*DRESET */
+					  (0 << 4) | /*ENB_CLKOUT */
+					  (0 << 5) | /*BYPEN ??? */
+					  (0 << 6) | /*PWRDWN_CH1 */
+					  (0 << 8) | /*DLY_CH1 */
+					  (0 << 10)| /*VCO_RNG */
+					  (1 << 31)  /*DIV2 CLK RESET */
+					  );
+
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_PRE_DIVIDER,
+						(1 << 0) | /*P1DIV */
+						(1 << 4) | /*P2DIV */
+						(PLL_NDIV_INT[i] << 8) | /*NDIV_INT */
+						(1 << 24) /*BYPASS_SDMOD */
+						);
+
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_DIVIDER,
+						(PLL_M1DIV[i] << 24) /*M1DIV */
+						);
+
+			config = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG);
+			config &= 0xfffffffb; /*clear ARESET */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG, config);
+		}
+
+		/*poll for lock */
+		for(i=0;i<num_plls;i++){
+			if (skip_init[i]) continue;
+			timeout = 10;
+			tmp = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_STATUS);
+			while((timeout>0) && ((tmp & 0x1) == 0)){
+				msleep_interruptible(1);
+				tmp = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_STATUS);
+				timeout--;
+			}
+			if (timeout<=0)
+				printk("Timed out waiting for DDR Controller PLL %d to lock\n",i);
+		}
+
+		/*deassert PLL digital reset */
+		for(i=0;i<num_plls;i++){
+			if (skip_init[i]) continue;
+			config = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG);
+			config &= 0xfffffff7; /*clear DRESET */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG, config);
+		}
+
+		/*deassert reset of logic */
+		for(i=0;i<num_plls;i++){
+			if (skip_init[i]) continue;
+			config = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG);
+			config &= 0x7fffffff; /*clear logic reset */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG, config);
+		}
+	} /* end (skip_pll_setup) */
+
+	/*run VDL calibration for all byte lanes */
+	for(i=0;i<num_plls;i++) {
+		if (skip_init[i]) continue;
+		tmp = 0;
+		hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_VDL_CALIBRATE,tmp);
+		hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_VDL_CALIBRATE,tmp);
+		tmp = (
+			(1 << 0) | /*calib_fast */
+			(1 << 1)   /*calib_once */
+			);
+		hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_VDL_CALIBRATE,tmp);
+		hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_VDL_CALIBRATE,tmp);
+
+
+		if (!skip_pll_setup){  /*VDLs might not lock if clocks are bypassed */
+			timeout=100;
+			tmp = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_VDL_STATUS);
+			while((timeout>0) && ((tmp & 0x3) == 0x0)){
+				msleep_interruptible(1);
+				timeout--;
+				tmp = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_VDL_STATUS);
+			}
+			if ((tmp & 0x3) != 0x3)
+				printk("VDL calibration did not finish or did not lock!\n");
+			timeout=100;
+			tmp = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_VDL_STATUS);
+			while((timeout>0) && ((tmp & 0x3) == 0x0)){
+				msleep_interruptible(1);
+				timeout--;
+				tmp = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_VDL_STATUS);
+			}
+			if ((tmp & 0x3) != 0x3)
+				printk("VDL calibration did not finish or did not lock!\n");
+
+			if(timeout<=0){
+				printk("DDR PHY %d VDL Calibration failed\n",i);
+			}
+		}
+		else {
+			msleep_interruptible(1);
+		}
+
+		/*clear VDL calib settings */
+		tmp = 0;
+		hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_VDL_CALIBRATE,tmp);
+		hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_VDL_CALIBRATE,tmp);
+
+		/*override the ADDR/CTRL VDLs with results from Bytelane #0 */
+		/*if tmode other than zero then set the VDL compensations to max values of 0x1ff. */
+		tmp = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_VDL_STATUS);
+		tmp = (tmp >> 4) & 0x3ff;
+		/* If in other than tmode 0 then set the VDL override settings to max. */
+		if (tmode) {
+			tmp = 0x3ff;
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_VDL_OVERRIDE_0, 0x1003f);
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_VDL_OVERRIDE_1, 0x1003f);
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_VDL_OVERRIDE_2, 0x1003f);
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_VDL_OVERRIDE_3, 0x1003f);
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_VDL_OVERRIDE_0, 0x1003f);
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_VDL_OVERRIDE_1, 0x1003f);
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_VDL_OVERRIDE_2, 0x1003f);
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_VDL_OVERRIDE_3, 0x1003f);
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_UPDATE_VDL, BCHP_DDR23_CTL_REGS_0_UPDATE_VDL_refresh_MASK);
+		}
+		hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_STATIC_VDL_OVERRIDE,
+			(((tmp & 0x3f0) >> 4) << 0) |  /* step override value */
+			(1 << 16)  |  /* override enable */
+			(1 << 20)     /* override force ; no update vdl required */
+			);
+
+		/* NAREN added support for ZQ Calibration */
+		hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_ZQ_PVT_COMP_CTL, 0);
+		hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_ZQ_PVT_COMP_CTL, BCHP_DDR23_PHY_CONTROL_REGS_ZQ_PVT_COMP_CTL_sample_en_MASK);
+		tmp = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_ZQ_PVT_COMP_CTL);
+
+		poll_cnt = 0;
+		while(1)
+		{
+			if(!(tmp & BCHP_DDR23_PHY_CONTROL_REGS_ZQ_PVT_COMP_CTL_sample_done_MASK))
+				tmp = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_ZQ_PVT_COMP_CTL);
+			else
+				break;
+
+			if(poll_cnt++ > 100)
+				break;
+		}
+
+		if(tmode) {
+			/* Set fields addr_ovr_en and dq_pvr_en to '1'.  Set all *_override_val fields to 0xf - ZQ_PVT_COMP_CTL */
+			tmp = ( (  1 << 25) |     /*  addr_ovr_en */
+					(  1 << 24) |     /*  dq_ovr_en */
+					(0xf << 12) |     /* addr_pd_override_val */
+					(0xf << 8)  |     /* addr_nd_override_val */
+					(0xf << 4)  |     /* dq_pd_override_val */
+					(0xf << 0)  );    /* dq_nd_override_val */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_ZQ_PVT_COMP_CTL, tmp);
+			/* Drive_PAD_CTL register.  Set field selrxdrv and slew to 0; */
+			tmp = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_DRIVE_PAD_CTL);
+			tmp &= (0xfffffffe);    /*clear bits 0 and 1. */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_DRIVE_PAD_CTL,tmp);
+		}
+	}/*for(i=0.. */
+}
+
+void crystalhd_flea_ddr_ctrl_init(struct crystalhd_hw *hw,
+								int32_t port,
+								int32_t ddr3,
+								int32_t speed_grade,
+								int32_t col,
+								int32_t bank,
+								int32_t row,
+								uint32_t tmode)
+{
+	/*uint32_t offset; */
+	/*uint32_t arb_refresh_addr; */
+	uint32_t port_int;
+
+	uint32_t data;
+
+	/*DDR2 Parameters */
+	uint8_t tRCD = 0;
+	uint8_t tRP = 0;
+	uint8_t tRRD = 0;
+	uint8_t tWR = 0;
+	uint8_t tWTR = 0;
+	uint8_t tCAS = 0;
+	uint8_t tWL = 0;
+	uint8_t tRTP = 0;
+	uint8_t tRAS = 0;
+	uint8_t tFAW = 0;
+	uint8_t tRFC = 0;
+	uint8_t INTLV_BYTES = 0;
+	uint8_t INTLV_DISABLE = 0;
+	uint8_t CTRL_BITS = 0;
+	uint8_t ALLOW_PICTMEM_RD = 0;
+	uint8_t DIS_DQS_ODT = 0;
+	uint8_t CS0_ONLY = 0;
+	uint8_t EN_ODT_EARLY = 0;
+	uint8_t EN_ODT_LATE = 0;
+	uint8_t USE_CHR_HGT = 0;
+	uint8_t DIS_ODT = 0;
+	uint8_t EN_2T_TIMING = 0;
+	uint8_t CWL = 0;
+	uint8_t DQ_WIDTH = 0;
+
+	uint8_t DM_IDLE_MODE = 0;
+	uint8_t CTL_IDLE_MODE = 0;
+	uint8_t DQ_IDLE_MODE = 0;
+
+	uint8_t DIS_LATENCY_CTRL = 0;
+
+	uint8_t PSPLIT = 0;
+	uint8_t DSPLIT = 0;
+
+	/* For each controller port, 0 and 1. */
+	for (port_int=0; port_int < 1; ++port_int)  {
+#if 0
+		printk("******************************************************\n");
+		printk("* Configuring DDR23 at addr=0x%x, speed grade [%s]\n",0,
+                ((speed_grade == DDR2_667MHZ) && (tmode == 0)) ? "667MHZ":
+                ((speed_grade == DDR2_533MHZ) && (tmode == 0)) ? "533MHZ":
+                ((speed_grade == DDR2_400MHZ) && (tmode == 0)) ? "400MHZ":
+                ((speed_grade == DDR2_333MHZ) && (tmode == 0)) ? "333MHZ":
+                ((speed_grade == DDR2_266MHZ) && (tmode == 0)) ? "266MHZ": "400MHZ" );
+#endif
+		/* Written in this manner to prevent table lookup in Memory for embedded MIPS code. */
+		/* Cannot use memory until it is inited!  Case statements with greater than 5 cases use memory tables */
+		/* when optimized.  Tony O 9/18/07 */
+		/* Note if not in test mode 0, choose the slowest clock speed. */
+		if (speed_grade == DDR2_200MHZ) {
+			tRCD = 3;
+			tRP = 3;
+			tRRD = 2;
+			tWR = 3;
+			tWTR = 2;
+			tCAS = 4;
+			tWL = 3;
+			tRTP = 2;
+			tRAS = 8;
+			tFAW = 10;
+			if (bank == BANK_SIZE_4)
+				tRFC = 21;
+			else /*BANK_SIZE_8 */
+				tRFC = 26;
+		}
+		else if (speed_grade == DDR2_266MHZ ) {
+			tRCD = 4;
+			tRP = 4;
+			tRRD = 3;
+			tWR = 4;
+			tWTR = 2;
+			tCAS = 4;
+			tWL = 3;
+			tRTP = 2;
+			tRAS = 11;
+			tFAW = 14;
+			if (bank == BANK_SIZE_4)
+				tRFC = 28;
+			else /*BANK_SIZE_8 */
+				tRFC = 34;
+		}
+		else if (speed_grade == DDR2_333MHZ) {
+			tRCD = 4;
+			tRP = 4;
+			tRRD = 4;
+			tWR = 5;
+			tWTR = 3;
+			tCAS = 4;
+			tWL = 3;
+			tRTP = 3;
+			tRAS = 14;
+			tFAW = 17;
+			if (bank == BANK_SIZE_4)
+				tRFC = 35;
+			else /*BANK_SIZE_8 */
+				tRFC = 43;
+		}
+		else if ((speed_grade == DDR2_400MHZ) || (tmode != 0)) { /* -25E timing */
+			tRCD = 6;
+			tRP = 6;
+			tRRD = 4;
+			tWR = 6;
+			tWTR = 4;
+			tCAS = ddr3 ? 6 : 5;
+			tWL = ddr3 ? 5 : 4;
+			tRTP = 3;
+			tRAS = 18;
+			tFAW = 20;
+			if (bank == BANK_SIZE_4)
+				tRFC = 42;
+			else /*BANK_SIZE_8 */
+				tRFC = 52;
+			CWL = tWL - 5;
+		}
+		else if (speed_grade == DDR2_533MHZ) { /* -187E timing */
+			tRCD = 7;
+			tRP = 7;
+			tRRD =  6;
+			tWR = 8;
+			tWTR = 4;
+			tCAS = 7;
+			tWL = tCAS - 1;
+			tRTP = 4;
+			tRAS = 22;
+			tFAW = 24;
+			tRFC = 68;
+			CWL = tWL - 5;
+		}
+		else if (speed_grade == DDR2_667MHZ) { /* -15E  timing */
+			tRCD = 9;
+			tRP = 9;
+			tRRD =  5;/* 4/5 */
+			tWR = 10;
+			tWTR = 5;
+			tCAS = 9;
+			tWL = 7;
+			tRTP = 5;
+			tRAS = 24;
+			tFAW = 30; /* 20/30 */
+			tRFC = 74;
+			CWL = tWL - 5;
+		}
+		else
+			printk("init: CANNOT HAPPEN - Memory DDR23 Ctrl_init failure. Incorrect speed grade type [%d]\n", speed_grade);
+
+		CTRL_BITS = 0; /* Control Bit for CKE signal */
+		EN_2T_TIMING = 0;
+		INTLV_DISABLE = ddr3 ? 1:0;  /* disable for DDR3, enable for DDR2 */
+		INTLV_BYTES = 0;
+		ALLOW_PICTMEM_RD = 0;
+		DIS_DQS_ODT = 0;
+		CS0_ONLY = 0;
+		EN_ODT_EARLY = 0;
+		EN_ODT_LATE = 0;
+		USE_CHR_HGT = 0;
+		DIS_ODT = 0;
+
+		/*Power Saving Controls */
+		DM_IDLE_MODE = 0;
+		CTL_IDLE_MODE = 0;
+		DQ_IDLE_MODE = 0;
+
+		/*Latency Control Setting */
+		DIS_LATENCY_CTRL = 0;
+
+		/* ****** Start of Grain/Flea specific fixed settings ***** */
+		CS0_ONLY = 1 ;      /* 16-bit mode only */
+		INTLV_DISABLE = 1 ; /* Interleave is always disabled */
+		DQ_WIDTH = 16 ;
+		/* ****** End of Grain specific fixed settings ***** */
+
+#if 0
+		printk("* DDR23 Config: CAS: %d, tRFC: %d, INTLV: %d, WIDTH: %d\n",
+				tCAS,tRFC,INTLV_BYTES,DQ_WIDTH);
+		printk("******************************************************\n");
+#endif
+		/*Disable refresh */
+		data = ((0x68 << 0) |  /*Refresh period */
+				(0x0 << 12)    /*disable refresh */
+				);
+
+		hw->pfnWriteDevRegister(hw->adp, BCHP_PRI_ARB_CONTROL_REGS_REFRESH_CTL_0, data);
+
+		/* DecSd_Ddr2Param1 */
+		data = 0;
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS1, trcd, tRCD); /* trcd */
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS1, trp, tRP); /* trp */
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS1, trrd, tRRD);  /* trrd */
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS1, twr, tWR);  /* twr */
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS1, twtr, tWTR);  /* twtr */
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS1, tcas, tCAS);  /* tcas */
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS1, twl, tWL); /* twl */
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS1, trtp, tRTP); /* trtp */
+
+		hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_PARAMS1,  data );
+
+		/*DecSd_Ddr2Param3 - deassert reset only */
+		data = 0;
+		/*DEBUG_PRINT(PARAMS3, data); */
+		hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_PARAMS3,  data );
+
+		/* Reset must be deasserted 500us before CKE. This needs */
+		/* to be reflected in the CFE. (add delay here) */
+
+		/*DecSd_Ddr2Param2 */
+		data = 0;
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS2, tras, tRAS);  /* tras */
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS2, tfaw, tFAW); /* tfaw */
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS2, trfc, tRFC); /* trfc */
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS2, bank_bits, bank & 1); /*  0 = bank size of 4K == 2bits, 1 = bank size of 8k == 3 bits */
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS2, allow_pictmem_rd, ALLOW_PICTMEM_RD);
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS2, cs0_only, CS0_ONLY);
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS2, dis_itlv, INTLV_DISABLE); /* #disable interleave */
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS2, il_sel, INTLV_BYTES); /* #bytes per interleave */
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS2, sd_col_bits, col & 3); /* column bits, 0 = 9, 1= 10, 2 or 3 = 11 bits */
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS2, clke, CTRL_BITS); /* Control Bit for CKE signal */
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS2, use_chr_hgt, USE_CHR_HGT);
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS2, row_bits, row & 1); /* row size 1 is 16K for 2GB device, otherwise 0 and 8k sized */
+
+		/*DEBUG_PRINT(PARAMS2, data); */
+		hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_PARAMS2,  data );
+
+		/*DecSd_Ddr2Param3. */
+		data = 0;
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS3, wr_odt_en, DIS_ODT ? 0 : 1);
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS3, wr_odt_le_adj, EN_ODT_EARLY ? 1 : 0);
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS3, wr_odt_te_adj, EN_ODT_LATE ? 1 : 0);
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS3, cmd_2t, EN_2T_TIMING ? 1: 0);  /* 2T timing is disabled */
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS3, ddr_bl, ddr3 ? 1: 0);  /* 0 for DDR2, 1 for DDR3 */
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS3, wr_odt_mode, ddr3 ? 1:0);  /* ddr3 preamble */
+		SET_FIELD(data, BCHP_DDR23_CTL_REGS_0, PARAMS3, ddr3_reset, ddr3 ? 0:1);  /* ddr3 reset */
+
+		/*DEBUG_PRINT(PARAMS3, data); */
+		hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_PARAMS3,  data );
+	} /* for( port_int......) */
+
+	data = 0;
+	SET_FIELD(data, BCHP_DDR23_PHY_CONTROL_REGS, DRIVE_PAD_CTL, slew, 1);
+	SET_FIELD(data, BCHP_DDR23_PHY_CONTROL_REGS, DRIVE_PAD_CTL, seltxdrv_ci, 1);
+	SET_FIELD(data, BCHP_DDR23_PHY_CONTROL_REGS, DRIVE_PAD_CTL, sel_sstl18, ddr3 ? 0 : 1);
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_DRIVE_PAD_CTL, data );
+
+	data = 0;
+	SET_FIELD(data, BCHP_DDR23_PHY_BYTE_LANE_0, DRIVE_PAD_CTL, slew, 0);
+	SET_FIELD(data, BCHP_DDR23_PHY_BYTE_LANE_0, DRIVE_PAD_CTL, selrxdrv, 0);
+	SET_FIELD(data, BCHP_DDR23_PHY_BYTE_LANE_0, DRIVE_PAD_CTL, seltxdrv_ci, 0);
+	SET_FIELD(data, BCHP_DDR23_PHY_BYTE_LANE_0, DRIVE_PAD_CTL, sel_sstl18, ddr3 ? 0 : 1);
+	SET_FIELD(data, BCHP_DDR23_PHY_BYTE_LANE_0, DRIVE_PAD_CTL, rt60b, 0);
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL, data );
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_DRIVE_PAD_CTL, data );
+
+	data = 0;
+
+	if (speed_grade == DDR2_667MHZ) {
+		data = ((data & ~BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_rd_data_dly_MASK) | ((2 << BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_rd_data_dly_SHIFT) & BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_rd_data_dly_MASK));
+	} else {
+		data = ((data & ~BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_rd_data_dly_MASK) | ((1 << BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_rd_data_dly_SHIFT) & BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_rd_data_dly_MASK));
+	}
+
+	data = ((data & ~BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_dq_odt_enable_MASK) | ((((DIS_DQS_ODT || DIS_ODT) ? 0:1) << BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_dq_odt_enable_SHIFT) & BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_dq_odt_enable_MASK));
+	data = ((data & ~BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_dq_odt_adj_MASK) | (((EN_ODT_EARLY ? 1 : 0) << BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_dq_odt_adj_SHIFT) & BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_dq_odt_adj_MASK));
+	data = ((data & ~BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_rd_enb_odt_enable_MASK) | (((DIS_ODT ? 0:1) << BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_rd_enb_odt_enable_SHIFT) & BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_rd_enb_odt_enable_MASK));
+	data = ((data & ~BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_rd_enb_odt_adj_MASK) | (((EN_ODT_EARLY ? 1 : 0) << BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_rd_enb_odt_adj_SHIFT) & BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_rd_enb_odt_adj_MASK));
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL, data);
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_READ_CONTROL, data);
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_WR_PREAMBLE_MODE, ddr3 ? 1 : 0);
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_WR_PREAMBLE_MODE, ddr3 ? 1 : 0);
+
+	/* Disable unused clocks */
+
+	for (port_int=0; port_int<1; ++port_int) { /* For Grain */
+		/* Changes for Grain/Flea */
+		/*offset = 0; */
+		/*arb_refresh_addr = BCHP_PRI_ARB_CONTROL_REGS_REFRESH_CTL_0; */
+		/*offset += GLOBAL_REG_RBUS_START; */
+		/* Changes for Grain - till here */
+
+		if (ddr3) {
+			data = (CWL & 0x07) << 3;
+			/*DEBUG_PRINT(LOAD_EMODE2_CMD, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_LOAD_EMODE2_CMD,  data );
+
+			data = 0;
+			/*DEBUG_PRINT(LOAD_EMODE3_CMD, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_LOAD_EMODE3_CMD,  data );
+
+			data = 6;  /* was 4; */
+			/*DEBUG_PRINT(LOAD_EMODE_CMD, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_LOAD_EMODE_CMD,  data );
+
+			data = 0x1100;   /* Reset DLL */
+			data += ((tWR-4) << 9);
+			data += ((tCAS-4) << 4);
+			/*DEBUG_PRINT(LOAD_MODE_CMD, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_LOAD_MODE_CMD,  data );
+
+
+			data = 0x0400;  /* long calibration */
+			/*DEBUG_PRINT(ZQ_CALIBRATE, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_ZQ_CALIBRATE,  data );
+
+			msleep_interruptible(1);
+		}
+		else
+		{
+			/*DecSd_RegSdPrechCmd    // Precharge */
+			data = 0;
+			/*DEBUG_PRINT(PRECHARGE_CMD, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_PRECHARGE_CMD,  data );
+
+			/*DEBUG_PRINT(PRECHARGE_CMD, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_PRECHARGE_CMD,  data );
+
+			/*DecSd_RegSdLdModeCmd   //Clear EMODE 2,3 */
+			data = 0;
+			/*DEBUG_PRINT(LOAD_EMODE2_CMD, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_LOAD_EMODE2_CMD,  data );
+
+			/*DEBUG_PRINT(LOAD_EMODE3_CMD, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_LOAD_EMODE3_CMD,  data );
+
+			/*DecSd_RegSdLdEmodeCmd  // Enable DLL ; Rtt ; enable OCD */
+			data = 0x3C0;
+			/*DEBUG_PRINT(LOAD_EMODE_CMD, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_LOAD_EMODE_CMD,  data );
+
+			/*DecSd_RegSdLdModeCmd */
+			data = 0x102;   /* Reset DLL */
+			data += ((tWR-1) << 9);
+			data += (tCAS << 4);
+			/*DEBUG_PRINT(LOAD_MODE_CMD, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_LOAD_MODE_CMD,  data );
+
+			/*DecSd_RegSdPrechCmd    // Precharge */
+			data = 0;
+			/*DEBUG_PRINT(PRECHARGE_CMD, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_PRECHARGE_CMD,  data );
+
+			/*DEBUG_PRINT(PRECHARGE_CMD, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_PRECHARGE_CMD,  data );
+
+			/*DecSd_RegSdRefCmd      // Refresh */
+			data = 0x69;
+			/*DEBUG_PRINT(REFRESH_CMD, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_REFRESH_CMD,  data );
+
+			/*DEBUG_PRINT(REFRESH_CMD, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_REFRESH_CMD,  data );
+
+			/*DecSd_RegSdLdModeCmd */
+			data = 0x002;   /* Un-Reset DLL */
+			data += ((tWR-1) << 9);
+			data += (tCAS << 4);
+			/*DEBUG_PRINT(LOAD_MODE_CMD, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_LOAD_MODE_CMD,  data );
+
+			/*DecSd_RegSdLdEmodeCmd  // Enable DLL ; Rtt ; enable OCD */
+			data = 0x3C0;
+			/*DEBUG_PRINT(LOAD_EMODE_CMD, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_LOAD_EMODE_CMD,  data );
+
+			/*DecSd_RegSdLdEmodeCmd  // Enable DLL ; Rtt ; disable OCD */
+			data = 0x40;
+			/*DEBUG_PRINT(LOAD_EMODE_CMD, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_LOAD_EMODE_CMD,  data );
+		}
+
+		/*Enable refresh */
+		data = ((0x68 << 0) |  /*Refresh period */
+				(0x1 << 12)    /*enable refresh */
+				);
+		if (tmode == 0) {
+			/*MemSysRegWr(arb_refresh_addr + GLOBAL_REG_RBUS_START,data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_PRI_ARB_CONTROL_REGS_REFRESH_CTL_0,data);
+		}
+
+		/*offset = 0; */
+		/*offset += GLOBAL_REG_RBUS_START; */
+
+		/* Use this scratch register in DDR0 as a simple symaphore for the test */
+		/* to monitor if and when the Initialization of the DDR is complete. Seeing a non zero value */
+		/* indicates DDR init complete.  This code is ONLY for the MIPS. It has no affect in init.c */
+		/* The MIPS executes this code and we wait until DDR 1 is inited before setting the semaphore. */
+		if ( port_int == 1)
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_SCRATCH, 0xff);
+
+		/*Setup the Arbiter Data and Pict Buffer split if specified */
+		if (port_int==0) { /*only need to do this once */
+			/*where is the pict buff split (2 bits) */
+			/*0 = always mem_a, 1 = (<128 is mem_a), 2 = (<64 is mem_a), 3 = always mem_b */
+			PSPLIT = 0;
+
+			/*0 = 32MB, 1 = 64MB, 2 = 128 MB, 3 = 256MB, 4=512MB */
+			DSPLIT = 4;
+
+			data = 0;
+			data += DSPLIT;
+			data += PSPLIT<< 4;
+			/* MemSysRegWr (PRI_ARB_CONTROL_REGS_CONC_CTL + offset,  data ); */
+		}
+
+		if (DIS_LATENCY_CTRL == 1){
+			/*set the work limit to the maximum */
+			/*DEBUG_PRINT(LATENCY, data); */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_LATENCY,  0x3ff );
+		}
+	} /* for (port_int=0......  ) */
+
+ return;
+}
+
+void crystalhd_flea_ddr_arb_rts_init(struct crystalhd_hw *hw)
+{
+	uint32_t addr_cnt;
+	uint32_t addr_ctrl;
+	uint32_t i;
+
+	addr_cnt = BCHP_PRI_CLIENT_REGS_CLIENT_00_COUNT;
+	addr_ctrl = BCHP_PRI_CLIENT_REGS_CLIENT_00_CONTROL;
+
+	/*Go through the various clients and program them */
+	for(i=0;i<21;i++){
+		if (rts_prog_vals[i][0] > 0) {
+			hw->pfnWriteDevRegister(hw->adp, addr_cnt,
+				(rts_prog_vals[i][1]) |        /*Blockout Count */
+				(rts_prog_vals[i][2] << 16)    /*Critical Period */
+				);
+			hw->pfnWriteDevRegister(hw->adp, addr_ctrl,
+				(rts_prog_vals[i][3]) |        /*Priority Level */
+				(rts_prog_vals[i][4] << 8)     /*Access Mode */
+				);
+		}
+		addr_cnt+=8;
+		addr_ctrl+=8;
+	}
+}
diff --git a/drivers/staging/crystalhd/crystalhd_flea_ddr.h b/drivers/staging/crystalhd/crystalhd_flea_ddr.h
new file mode 100644
index 0000000..a981a90
--- /dev/null
+++ b/drivers/staging/crystalhd/crystalhd_flea_ddr.h
@@ -0,0 +1,73 @@
+/***************************************************************************
+ * Copyright (c) 2005-2010, Broadcom Corporation.
+ *
+ *  Name: crystalhd_flea_ddr . h
+ *
+ *  Description:
+ *		BCM70015 generic DDR routines
+ *
+ *  HISTORY:
+ *
+ **********************************************************************
+ * This file is part of the crystalhd device driver.
+ *
+ * This driver is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * This driver is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this driver.  If not, see <http://www.gnu.org/licenses/>.
+ **********************************************************************/
+
+#undef  BRCM_ALIGN
+#define BRCM_ALIGN(c,r,f)   0
+
+#define MEM_SYS_NUM_DDR_PLLS 2;
+
+/*extern uint32_t rts_prog_vals[][5]; */
+
+enum eDDR2_SPEED_GRADE {
+  DDR2_400MHZ = 0x0,
+  DDR2_333MHZ = 0x1,
+  DDR2_266MHZ = 0x2,
+  DDR2_200MHZ = 0x3,
+  DDR2_533MHZ = 0x4,
+  DDR2_667MHZ = 0x5
+};
+
+enum eSD_COL_SIZE {
+  COL_BITS_9  = 0x0,
+  COL_BITS_10 = 0x1,
+  COL_BITS_11 = 0x2,
+};
+
+enum eSD_BANK_SIZE {
+  BANK_SIZE_4  = 0x0,
+  BANK_SIZE_8  = 0x1,
+};
+
+enum eSD_ROW_SIZE {
+  ROW_SIZE_8K  = 0x0,
+  ROW_SIZE_16K = 0x1,
+};
+
+/*DDR PHY PLL init routine */
+void crystalhd_flea_ddr_pll_config(struct crystalhd_hw* hw, int32_t *speed_grade, int32_t num_plls, uint32_t tmode);
+
+/*DDR controller init routine */
+void crystalhd_flea_ddr_ctrl_init(struct crystalhd_hw *hw,
+						int32_t port,
+                        int32_t ddr3,
+                        int32_t speed_grade,
+                        int32_t col,
+                        int32_t bank,
+                        int32_t row,
+                        uint32_t tmode );
+
+/*RTS Init routines */
+void crystalhd_flea_ddr_arb_rts_init(struct crystalhd_hw *hw);
diff --git a/drivers/staging/crystalhd/crystalhd_fleafuncs.c b/drivers/staging/crystalhd/crystalhd_fleafuncs.c
new file mode 100644
index 0000000..d50dec2
--- /dev/null
+++ b/drivers/staging/crystalhd/crystalhd_fleafuncs.c
@@ -0,0 +1,2952 @@
+/***************************************************************************
+ * Copyright (c) 2005-2009, Broadcom Corporation.
+ *
+ *  Name: crystalhd_fleafuncs.c
+ *
+ *  Description:
+ *		BCM70015 Linux driver HW layer.
+ *
+ *  HISTORY:
+ *
+ **********************************************************************
+ * This file is part of the crystalhd device driver.
+ *
+ * This driver is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * This driver is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this driver.  If not, see <http://www.gnu.org/licenses/>.
+ **********************************************************************/
+
+#include "crystalhd.h"
+
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <asm/tsc.h>
+#include <asm/msr.h>
+
+#define OFFSETOF(_s_, _m_) ((size_t)(unsigned long)&(((_s_ *)0)->_m_))
+
+void crystalhd_flea_core_reset(struct crystalhd_hw *hw)
+{
+	unsigned int pollCnt=0,regVal=0;
+
+	dev_dbg(&hw->adp->pdev->dev,"[crystalhd_flea_core_reset]: Starting core reset\n");
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_MISC3_RESET_CTRL,	0x01);
+
+	pollCnt=0;
+	while (1)
+	{
+		pollCnt++;
+		regVal=0;
+
+		msleep_interruptible(1);
+
+		regVal = hw->pfnReadDevRegister(hw->adp, BCHP_MISC3_RESET_CTRL);
+
+		if(!(regVal & 0x01))
+		{
+			/*
+			-- Bit is 0, Reset is completed. Which means that
+			-- wait for sometime and then allow other accesses.
+			*/
+			msleep_interruptible(1);
+			break;
+		}
+
+		if(pollCnt > MAX_VALID_POLL_CNT)
+		{
+			printk("!!FATAL ERROR!! Core Reset Failure\n");
+			break;
+		}
+	}
+
+	msleep_interruptible(5);
+
+	return;
+}
+
+void crystalhd_flea_disable_interrupts(struct crystalhd_hw *hw)
+{
+	union FLEA_INTR_BITS_COMMON IntrMaskReg;
+	/*
+	-- Mask everything except the reserved bits.
+	*/
+	IntrMaskReg.WholeReg =0xffffffff;
+	IntrMaskReg.Reserved1=0;
+	IntrMaskReg.Reserved2=0;
+	IntrMaskReg.Reserved3=0;
+	IntrMaskReg.Reserved4=0;
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_INTR_INTR_MSK_SET_REG, IntrMaskReg.WholeReg);
+
+	return;
+}
+
+void crystalhd_flea_enable_interrupts(struct crystalhd_hw *hw)
+{
+	union FLEA_INTR_BITS_COMMON IntrMaskReg;
+	/*
+	-- Clear The Mask for everything except the reserved bits.
+	*/
+	IntrMaskReg.WholeReg =0xffffffff;
+	IntrMaskReg.Reserved1=0;
+	IntrMaskReg.Reserved2=0;
+	IntrMaskReg.Reserved3=0;
+	IntrMaskReg.Reserved4=0;
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_INTR_INTR_MSK_CLR_REG, IntrMaskReg.WholeReg);
+
+	return;
+}
+
+void crystalhd_flea_clear_interrupts(struct crystalhd_hw *hw)
+{
+	union FLEA_INTR_BITS_COMMON	IntrStsValue;
+
+	IntrStsValue.WholeReg = hw->pfnReadDevRegister(hw->adp, BCHP_INTR_INTR_STATUS);
+
+	if(IntrStsValue.WholeReg)
+	{
+		hw->pfnWriteDevRegister(hw->adp, BCHP_INTR_INTR_CLR_REG, IntrStsValue.WholeReg);
+		hw->pfnWriteDevRegister(hw->adp, BCHP_INTR_EOI_CTRL, 1);
+	}
+
+	return;
+}
+
+bool crystalhd_flea_detect_ddr3(struct crystalhd_hw *hw)
+{
+	uint32_t regVal = 0;
+
+	/*Set the Multiplexer to select the GPIO-6*/
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_SUN_TOP_CTRL_PIN_MUX_CTRL_0);
+
+	/*Make sure that the bits-24:27 are reset*/
+	if(regVal & 0x0f000000)
+	{
+		regVal = regVal & 0xf0ffffff; /*Clear bit 24-27 for selecting GPIO_06*/
+		hw->pfnWriteDevRegister(hw->adp, BCHP_SUN_TOP_CTRL_PIN_MUX_CTRL_0, regVal);
+	}
+
+	regVal=0;
+	/*Set the Direction of GPIO-6*/
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_GIO_IODIR_LO);
+
+	if(!(regVal & BC_BIT(6)))
+	{
+		/*Set the Bit number 6 to make the GPIO6 as input*/
+		regVal |= BC_BIT(6);
+		hw->pfnWriteDevRegister(hw->adp, BCHP_GIO_IODIR_LO, regVal);
+	}
+
+	regVal=0;
+	regVal = hw->pfnReadDevRegister(hw->adp,	BCHP_GIO_DATA_LO);
+
+	/*If this bit is clear then have DDR-3 else we have DDR-2*/
+	if(!(regVal & BC_BIT(6)))
+	{
+		dev_dbg(&hw->adp->pdev->dev,"DDR-3 Detected\n");
+		return true;
+	}
+	dev_dbg(&hw->adp->pdev->dev,"DDR-2 Detected\n");
+	return false;
+}
+
+void crystalhd_flea_init_dram(struct crystalhd_hw *hw)
+{
+	int32_t ddr2_speed_grade[2];
+	uint32_t sd_0_col_size, sd_0_bank_size, sd_0_row_size;
+	uint32_t sd_1_col_size, sd_1_bank_size, sd_1_row_size;
+	uint32_t ddr3_mode[2];
+	uint32_t regVal;
+	bool bDDR3Detected=false; /*Should be filled in using the detection logic. Default to DDR2 */
+
+	/* On all designs we are using DDR2 or DDR3 x16 and running at a max of 400Mhz */
+	/* Only one bank of DDR supported. The other is a dummy */
+
+	ddr2_speed_grade[0] = DDR2_400MHZ;
+	ddr2_speed_grade[1] = DDR2_400MHZ;
+	sd_0_col_size = COL_BITS_10;
+	sd_0_bank_size = BANK_SIZE_8;
+	sd_0_row_size = ROW_SIZE_8K; /* DDR2 */
+	/*	sd_0_row_size = ROW_SIZE_16K; // DDR3 */
+	sd_1_col_size = COL_BITS_10;
+	sd_1_bank_size = BANK_SIZE_8;
+	sd_1_row_size = ROW_SIZE_8K;
+	ddr3_mode[0] = 0;
+	ddr3_mode[1] = 0;
+
+	bDDR3Detected = crystalhd_flea_detect_ddr3(hw);
+	if(bDDR3Detected)
+	{
+		ddr3_mode[0] = 1;
+		sd_0_row_size = ROW_SIZE_16K; /* DDR3 */
+		sd_1_row_size = ROW_SIZE_16K; /* DDR3 */
+
+	}
+
+	/* Step 1. PLL Init */
+	crystalhd_flea_ddr_pll_config(hw, ddr2_speed_grade, 1, 0); /* only need to configure PLLs in TM0 */
+
+	/* Step 2. DDR CTRL Init */
+	crystalhd_flea_ddr_ctrl_init(hw, 0, ddr3_mode[0], ddr2_speed_grade[0], sd_0_col_size, sd_0_bank_size, sd_0_row_size, 0);
+
+	/* Step 3 RTS Init - Real time scheduling memory arbiter */
+	crystalhd_flea_ddr_arb_rts_init(hw);
+
+	/* NAREN turn off ODT. The REF1 and SV1 and most customer designs allow this. */
+	/* IF SOMEONE COMPLAINS ABOUT MEMORY OR DATA CORRUPTION LOOK HERE FIRST */
+
+	/*hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_LOAD_EMODE_CMD, 0x02, false); */
+
+	/*regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_PARAMS3);
+	regVal &= ~(BCHP_DDR23_CTL_REGS_0_PARAMS3_wr_odt_en_MASK);
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_PARAMS3, regVal);*/
+
+	/*regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_DRIVE_PAD_CTL);
+	regVal |= BCHP_DDR23_PHY_BYTE_LANE_1_DRIVE_PAD_CTL_seltxdrv_ci_MASK;
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_DRIVE_PAD_CTL, regVal);
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL);
+	regVal |= BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL_seltxdrv_ci_MASK;
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_DRIVE_PAD_CTL, regVal);*/
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_CLOCK_PAD_DISABLE);
+	regVal |= BCHP_DDR23_PHY_BYTE_LANE_1_CLOCK_PAD_DISABLE_clk_pad_dis_MASK;
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_CLOCK_PAD_DISABLE, regVal);
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL);
+	regVal &= ~(BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL_dq_odt_enable_MASK);
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_READ_CONTROL, regVal);
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_READ_CONTROL);
+	regVal &= ~(BCHP_DDR23_PHY_BYTE_LANE_1_READ_CONTROL_dq_odt_enable_MASK);
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_READ_CONTROL, regVal);
+
+	return;
+}
+
+uint32_t crystalhd_flea_reg_rd(struct crystalhd_adp *adp, uint32_t reg_off)
+{
+	uint32_t baseAddr = reg_off >> 16;
+	void	*regAddr;
+
+	if (!adp) {
+		printk(KERN_ERR "%s: Invalid args\n", __func__);
+		return 0;
+	}
+
+	if(baseAddr == 0 || baseAddr == FLEA_GISB_DIRECT_BASE) /* Direct Mapped Region */
+	{
+		regAddr = adp->i2o_addr + (reg_off & 0x0000FFFF);
+		if(regAddr > (adp->i2o_addr + adp->pci_i2o_len)) {
+			dev_err(&adp->pdev->dev, "%s: reg_off out of range: 0x%08x\n",
+					__func__, reg_off);
+			return 0;
+		}
+		return readl(regAddr);
+	}
+	else /* non directly mapped region */
+	{
+		if(adp->pci_i2o_len < 0xFFFF) {
+			printk("Un-expected mapped region size\n");
+			return 0;
+		}
+		regAddr = adp->i2o_addr + FLEA_GISB_INDIRECT_ADDRESS;
+		writel(reg_off | 0x10000000, regAddr);
+		regAddr = adp->i2o_addr + FLEA_GISB_INDIRECT_DATA;
+		return readl(regAddr);
+	}
+}
+
+void crystalhd_flea_reg_wr(struct crystalhd_adp *adp, uint32_t reg_off, uint32_t val)
+{
+	uint32_t baseAddr = reg_off >> 16;
+	void	*regAddr;
+
+	if (!adp) {
+		printk(KERN_ERR "%s: Invalid args\n", __func__);
+		return;
+	}
+
+	if(baseAddr == 0 || baseAddr == FLEA_GISB_DIRECT_BASE) /* Direct Mapped Region */
+	{
+		regAddr = adp->i2o_addr + (reg_off & 0x0000FFFF);
+		if(regAddr > (adp->i2o_addr + adp->pci_i2o_len)) {
+			dev_err(&adp->pdev->dev, "%s: reg_off out of range: 0x%08x\n",
+					__func__, reg_off);
+					return ;
+		}
+		writel(val, regAddr);
+	}
+	else /* non directly mapped region */
+	{
+		if(adp->pci_i2o_len < 0xFFFF) {
+			printk("Un-expected mapped region size\n");
+			return;
+		}
+		regAddr = adp->i2o_addr + FLEA_GISB_INDIRECT_ADDRESS;
+		writel(reg_off | 0x10000000, regAddr);
+		regAddr = adp->i2o_addr + FLEA_GISB_INDIRECT_DATA;
+		writel(val, regAddr);
+	}
+}
+
+/**
+* crystalhd_flea_mem_rd - Read data from DRAM area.
+* @adp: Adapter instance
+* @start_off: Start offset.
+* @dw_cnt: Count in dwords.
+* @rd_buff: Buffer to copy the data from dram.
+*
+* Return:
+*	Status.
+*
+* Dram read routine.
+*/
+enum BC_STATUS crystalhd_flea_mem_rd(struct crystalhd_hw *hw, uint32_t start_off,
+								uint32_t dw_cnt, uint32_t *rd_buff)
+{
+	uint32_t ix = 0;
+	uint32_t addr = start_off, base;
+
+	if (!hw || !rd_buff) {
+		printk(KERN_ERR "%s: Invalid arg\n", __func__);
+		return BC_STS_INV_ARG;
+	}
+
+	if( hw->FleaPowerState == FLEA_PS_LP_COMPLETE ) {
+		/*printk(KERN_ERR "%s: Flea power down, cann't read memory.\n", __func__); */
+		return BC_STS_BUSY;
+	}
+
+	if((start_off + dw_cnt * 4) > FLEA_TOTAL_DRAM_SIZE) {
+		printk(KERN_ERR "Access beyond DRAM limit at Addr 0x%x and size 0x%x words\n", start_off, dw_cnt);
+		return BC_STS_ERROR;
+	}
+
+	/* Set the base addr for the 512kb window */
+	hw->pfnWriteDevRegister(hw->adp, BCHP_MISC2_DIRECT_WINDOW_CONTROL,
+							(addr & BCHP_MISC2_DIRECT_WINDOW_CONTROL_DIRECT_WINDOW_BASE_ADDR_MASK) | BCHP_MISC2_DIRECT_WINDOW_CONTROL_DIRECT_WINDOW_ENABLE_MASK);
+
+	for (ix = 0; ix < dw_cnt; ix++) {
+		rd_buff[ix] = readl(hw->adp->mem_addr + (addr & ~BCHP_MISC2_DIRECT_WINDOW_CONTROL_DIRECT_WINDOW_BASE_ADDR_MASK));
+		base = addr & BCHP_MISC2_DIRECT_WINDOW_CONTROL_DIRECT_WINDOW_BASE_ADDR_MASK;
+		addr += 4; /* DWORD access at all times */
+		if (base != (addr & BCHP_MISC2_DIRECT_WINDOW_CONTROL_DIRECT_WINDOW_BASE_ADDR_MASK)) {
+			/* Set the base addr for next 512kb window */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_MISC2_DIRECT_WINDOW_CONTROL,
+										(addr & BCHP_MISC2_DIRECT_WINDOW_CONTROL_DIRECT_WINDOW_BASE_ADDR_MASK) | BCHP_MISC2_DIRECT_WINDOW_CONTROL_DIRECT_WINDOW_ENABLE_MASK);
+		}
+	}
+	return BC_STS_SUCCESS;
+}
+
+/**
+* crystalhd_flea_mem_wr - Write data to DRAM area.
+* @adp: Adapter instance
+* @start_off: Start offset.
+* @dw_cnt: Count in dwords.
+* @wr_buff: Data Buffer to be written.
+*
+* Return:
+*	Status.
+*
+* Dram write routine.
+*/
+enum BC_STATUS crystalhd_flea_mem_wr(struct crystalhd_hw *hw, uint32_t start_off,
+								uint32_t dw_cnt, uint32_t *wr_buff)
+{
+	uint32_t ix = 0;
+	uint32_t addr = start_off, base;
+	uint32_t temp;
+
+	if (!hw || !wr_buff) {
+		printk(KERN_ERR "%s: Invalid arg\n", __func__);
+		return BC_STS_INV_ARG;
+	}
+
+	if( hw->FleaPowerState == FLEA_PS_LP_COMPLETE ) {
+		/*printk(KERN_ERR "%s: Flea power down, cann't write memory.\n", __func__); */
+		return BC_STS_BUSY;
+	}
+
+	if((start_off + dw_cnt * 4) > FLEA_TOTAL_DRAM_SIZE) {
+		printk("Access beyond DRAM limit at Addr 0x%x and size 0x%x words\n", start_off, dw_cnt);
+		return BC_STS_ERROR;
+	}
+
+	/* Set the base addr for the 512kb window */
+	hw->pfnWriteDevRegister(hw->adp, BCHP_MISC2_DIRECT_WINDOW_CONTROL,
+							(addr & BCHP_MISC2_DIRECT_WINDOW_CONTROL_DIRECT_WINDOW_BASE_ADDR_MASK) | BCHP_MISC2_DIRECT_WINDOW_CONTROL_DIRECT_WINDOW_ENABLE_MASK);
+
+	for (ix = 0; ix < dw_cnt; ix++) {
+		writel(wr_buff[ix], hw->adp->mem_addr + (addr & ~BCHP_MISC2_DIRECT_WINDOW_CONTROL_DIRECT_WINDOW_BASE_ADDR_MASK));
+		base = addr & BCHP_MISC2_DIRECT_WINDOW_CONTROL_DIRECT_WINDOW_BASE_ADDR_MASK;
+		addr += 4; /* DWORD access at all times */
+		if (base != (addr & BCHP_MISC2_DIRECT_WINDOW_CONTROL_DIRECT_WINDOW_BASE_ADDR_MASK)) {
+			/* Set the base addr for next 512kb window */
+			hw->pfnWriteDevRegister(hw->adp, BCHP_MISC2_DIRECT_WINDOW_CONTROL,
+									(addr & BCHP_MISC2_DIRECT_WINDOW_CONTROL_DIRECT_WINDOW_BASE_ADDR_MASK) | BCHP_MISC2_DIRECT_WINDOW_CONTROL_DIRECT_WINDOW_ENABLE_MASK);
+		}
+	}
+
+	/*Dummy Read To Flush Memory Arbitrator*/
+	crystalhd_flea_mem_rd(hw, start_off, 1, &temp);
+	return BC_STS_SUCCESS;
+}
+
+
+static
+void crystalhd_flea_runtime_power_up(struct crystalhd_hw *hw)
+{
+	uint32_t regVal;
+	uint64_t currTick;
+	uint32_t totalTick_Hi;
+	uint32_t TickSpentInPD_Hi;
+	uint64_t temp_64;
+	long totalTick_Hi_f;
+	long TickSpentInPD_Hi_f;
+
+	/*printk("RT PU \n"); */
+
+	/* NAREN This function restores clocks and power to the DRAM and to the core to bring the decoder back up to full operation */
+	/* Start the DRAM controller clocks first */
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_CLK_PM_CTRL);
+	regVal &= ~(BCHP_CLK_PM_CTRL_DIS_DDR_108_CLK_MASK |	BCHP_CLK_PM_CTRL_DIS_DDR_216_CLK_MASK);
+	hw->pfnWriteDevRegister(hw->adp, BCHP_CLK_PM_CTRL, regVal);
+
+	/* Delay to allow the DRAM clock to stabilize */
+	udelay(25);
+
+	/* Power Up PHY and start clocks on DRAM device */
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_CLOCK_REG_CONTROL);
+	regVal &= ~(BCHP_DDR23_PHY_CONTROL_REGS_CLOCK_REG_CONTROL_pwrdn_MASK);
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_CLOCK_REG_CONTROL, regVal);
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG);
+	regVal &= ~(BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG_PWRDN_MASK);
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG, regVal);
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_CLK_PM_CTRL,
+		~(BCHP_DDR23_PHY_CONTROL_REGS_CLK_PM_CTRL_DIS_DDR_CLK_MASK));
+
+	/* Delay to allow the PLL to lock */
+	udelay(25);
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_IDLE_PAD_CONTROL);
+	regVal &= ~(BCHP_DDR23_PHY_CONTROL_REGS_IDLE_PAD_CONTROL_idle_MASK );
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_IDLE_PAD_CONTROL, regVal);
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_CLOCK_REG_CONTROL);
+	regVal &= ~(BCHP_DDR23_PHY_BYTE_LANE_0_CLOCK_REG_CONTROL_pwrdn_MASK);
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_CLOCK_REG_CONTROL, regVal);
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_CLOCK_REG_CONTROL);
+	regVal &= ~(BCHP_DDR23_PHY_BYTE_LANE_1_CLOCK_REG_CONTROL_pwrdn_MASK);
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_CLOCK_REG_CONTROL, regVal);
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL);
+	regVal &= ~(BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_idle_MASK );
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL, regVal);
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL);
+	regVal &= ~(BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_idle_MASK );
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL, regVal);
+
+	/* Start Refresh Cycles from controller */
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_PRI_ARB_CONTROL_REGS_REFRESH_CTL_0);
+	regVal |= BCHP_PRI_ARB_CONTROL_REGS_REFRESH_CTL_0_enable_MASK;
+	hw->pfnWriteDevRegister(hw->adp, BCHP_PRI_ARB_CONTROL_REGS_REFRESH_CTL_0, regVal);
+
+	/* turn off self-refresh */
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_PARAMS2);
+	regVal &= ~(BCHP_DDR23_CTL_REGS_0_PARAMS2_clke_MASK);
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_PARAMS2, regVal);
+
+	udelay(5);
+
+	/* Issue refresh cycle */
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_REFRESH_CMD, 0x60);
+
+	/* Enable the ARM AVD and BLINK clocks */
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_CLK_PM_CTRL);
+
+	regVal &= ~(BCHP_CLK_PM_CTRL_DIS_ARM_CLK_MASK |
+				BCHP_CLK_PM_CTRL_DIS_AVD_CLK_MASK |
+				BCHP_CLK_PM_CTRL_DIS_BLINK_108_CLK_MASK |
+				BCHP_CLK_PM_CTRL_DIS_AVD_108_CLK_MASK |
+				BCHP_CLK_PM_CTRL_DIS_BLINK_216_CLK_MASK |
+				BCHP_CLK_PM_CTRL_DIS_AVD_216_CLK_MASK);
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_CLK_PM_CTRL, 0x03000000);
+
+	/* Start arbiter */
+	hw->pfnWriteDevRegister(hw->adp, BCHP_PRI_ARB_CONTROL_REGS_MASTER_CTL, BCHP_PRI_ARB_CONTROL_REGS_MASTER_CTL_arb_disable_Enable);
+
+#ifdef _POWER_HANDLE_AVD_WATCHDOG_
+	/* Restore Watchdog timers */
+	/* Make sure the timeouts do not happen */
+	/*Outer Loop Watchdog timer */
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DECODE_CPUREGS_0_REG_WATCHDOG_TMR, hw->OLWatchDogTimer);
+
+	/*//Inner Loop Watchdog timer */
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DECODE_CPUREGS2_0_REG_WATCHDOG_TMR, hw->ILWatchDogTimer);
+
+#endif
+
+	/*printk("RT Power Up Flea Complete\n"); */
+
+	rdtscll(currTick);
+
+	hw->TickSpentInPD += (currTick - hw->TickStartInPD);
+
+	temp_64 = (hw->TickSpentInPD)>>24;
+	TickSpentInPD_Hi = (uint32_t)(temp_64);
+	TickSpentInPD_Hi_f = (long)TickSpentInPD_Hi;
+
+	temp_64 = (currTick - hw->TickCntDecodePU)>>24;
+	totalTick_Hi = (uint32_t)(temp_64);
+	totalTick_Hi_f = (long)totalTick_Hi;
+
+	if( totalTick_Hi_f <= 0 )
+	{
+		temp_64 = (hw->TickSpentInPD);
+		TickSpentInPD_Hi = (uint32_t)(temp_64);
+		TickSpentInPD_Hi_f = (long)TickSpentInPD_Hi;
+
+		temp_64 = (currTick - hw->TickCntDecodePU);
+		totalTick_Hi = (uint32_t)(temp_64);
+		totalTick_Hi_f = (long)totalTick_Hi;
+	}
+
+	if( totalTick_Hi_f <= 0 )
+	{
+		printk("totalTick_Hi_f <= 0, set hw->PDRatio = 60\n");
+		hw->PDRatio = 60;
+	}
+	else
+		hw->PDRatio = (TickSpentInPD_Hi_f * 100) / totalTick_Hi_f;
+
+	/*printk("Ticks currently spent in PD: 0x%llx Total: 0x%llx Ratio %d,\n", */
+	/*	hw->TickSpentInPD, (currTick - hw->TickCntDecodePU), hw->PDRatio); */
+
+	/* NAREN check if the PD ratio is greater than 75. If so, try to increase the PauseThreshold to improve the ratio */
+	/* never go higher than the default threshold */
+	if((hw->PDRatio > 75) && (hw->PauseThreshold < hw->DefaultPauseThreshold))
+	{
+		/*printk("Current PDRatio:%u, PauseThreshold:%u, DefaultPauseThreshold:%u, incress PauseThreshold.\n", */
+		/*		hw->PDRatio, hw->PauseThreshold, hw->DefaultPauseThreshold); */
+		hw->PauseThreshold++;
+	}
+	else
+	{
+		/*printk("Current PDRatio:%u, PauseThreshold:%u, DefaultPauseThreshold:%u, don't incress PauseThreshold.\n", */
+		/*		hw->PDRatio, hw->PauseThreshold, hw->DefaultPauseThreshold); */
+	}
+
+	return;
+}
+
+static
+void crystalhd_flea_runtime_power_dn(struct crystalhd_hw *hw)
+{
+	uint32_t regVal;
+	uint32_t pollCnt;
+
+	/*printk("RT PD \n"); */
+
+	hw->DrvPauseCnt++;
+
+	/* NAREN This function stops the decoder clocks including the AVD, ARM and DRAM */
+	/* It powers down the DRAM device and places the DRAM into self-refresh */
+
+#ifdef _POWER_HANDLE_AVD_WATCHDOG_
+	/* Make sure the timeouts do not happen */
+	/* Because the AVD drops to a debug prompt and stops decoding if it hits any watchdogs */
+	/*Outer Loop Watchdog timer */
+	regVal = hw->pfnReadDevRegister(hw->adp,
+		BCHP_DECODE_CPUREGS_0_REG_WATCHDOG_TMR);
+
+	hw->OLWatchDogTimer = regVal;
+	hw->pfnWriteDevRegister(hw->adp,
+		BCHP_DECODE_CPUREGS_0_REG_WATCHDOG_TMR,
+		0xffffffff);
+
+	/*Inner Loop Watchdog timer */
+	regVal = hw->pfnReadDevRegister(hw->adp,
+		BCHP_DECODE_CPUREGS2_0_REG_WATCHDOG_TMR);
+
+	hw->ILWatchDogTimer = regVal;
+	hw->pfnWriteDevRegister(hw->adp,
+		BCHP_DECODE_CPUREGS2_0_REG_WATCHDOG_TMR,
+		0xffffffff);
+#endif
+
+	/* Stop memory arbiter first to freese memory access */
+	hw->pfnWriteDevRegister(hw->adp, BCHP_PRI_ARB_CONTROL_REGS_MASTER_CTL, BCHP_PRI_ARB_CONTROL_REGS_MASTER_CTL_arb_disable_Disable);
+
+	/* delay at least 15us for memory transactions to complete */
+	/* udelay(15); */
+
+	/* Wait for MEMC to become idle. Continue even if we are no since worst case this would just mean higher power consumption */
+	pollCnt=0;
+	while (pollCnt++ <= 400) /*200 */
+	{
+		regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_CTL_STATUS);
+
+		if(regVal & BCHP_DDR23_CTL_REGS_0_CTL_STATUS_idle_MASK)
+		{
+			/* udelay(10); */
+			break;
+		}
+		udelay(10);
+	}
+
+	/*If we failed Start the arbiter and return*/
+	if(!(regVal & BCHP_DDR23_CTL_REGS_0_CTL_STATUS_idle_MASK))
+	{
+		printk("RT PD : failed Start the arbiter and return.\n");
+		hw->pfnWriteDevRegister(hw->adp,
+			BCHP_PRI_ARB_CONTROL_REGS_MASTER_CTL,
+			BCHP_PRI_ARB_CONTROL_REGS_MASTER_CTL_arb_disable_Enable);
+		return;
+	}
+
+	/* Disable the AVD, ARM and BLINK clocks*/
+	/*regVal = hw->pfnReadDevRegister(hw->adp, BCHP_CLK_PM_CTRL);
+
+	regVal |=	BCHP_CLK_PM_CTRL_DIS_ARM_CLK_MASK |
+				BCHP_CLK_PM_CTRL_DIS_AVD_CLK_MASK |
+				BCHP_CLK_PM_CTRL_DIS_BLINK_108_CLK_MASK |
+				BCHP_CLK_PM_CTRL_DIS_AVD_108_CLK_MASK |
+				BCHP_CLK_PM_CTRL_DIS_BLINK_216_CLK_MASK |
+				BCHP_CLK_PM_CTRL_DIS_AVD_216_CLK_MASK;
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_CLK_PM_CTRL, regValE);*/
+
+	/* turn on self-refresh */
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_PARAMS2);
+	regVal |= BCHP_DDR23_CTL_REGS_0_PARAMS2_clke_MASK;
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_PARAMS2, regVal);
+
+	/* Issue refresh cycle */
+	hw->pfnWriteDevRegister(hw->adp,	BCHP_DDR23_CTL_REGS_0_REFRESH_CMD, 0x60);
+
+	/* Stop Refresh Cycles from controller */
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_PRI_ARB_CONTROL_REGS_REFRESH_CTL_0);
+	regVal &= ~(BCHP_PRI_ARB_CONTROL_REGS_REFRESH_CTL_0_enable_MASK);
+	hw->pfnWriteDevRegister(hw->adp, BCHP_PRI_ARB_CONTROL_REGS_REFRESH_CTL_0, regVal);
+
+	/* Check if we are in self-refresh. Continue even if we are no since worst case this would just mean higher power consumption */
+	pollCnt=0;
+	while(pollCnt++ < 100)
+	{
+		regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_CTL_STATUS);
+
+		if(!(regVal & BCHP_DDR23_CTL_REGS_0_CTL_STATUS_clke_MASK))
+			break;
+	}
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_CLK_PM_CTRL);
+
+	regVal |=	BCHP_CLK_PM_CTRL_DIS_ARM_CLK_MASK |
+				BCHP_CLK_PM_CTRL_DIS_AVD_CLK_MASK |
+				BCHP_CLK_PM_CTRL_DIS_BLINK_108_CLK_MASK |
+				BCHP_CLK_PM_CTRL_DIS_AVD_108_CLK_MASK |
+				BCHP_CLK_PM_CTRL_DIS_BLINK_216_CLK_MASK |
+				BCHP_CLK_PM_CTRL_DIS_AVD_216_CLK_MASK;
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_CLK_PM_CTRL, regVal);
+
+	/* Power down PHY and stop clocks on DRAM */
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL);
+
+	regVal |=	BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_idle_MASK |
+				BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_dm_iddq_MASK |
+				BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_dq_iddq_MASK |
+				BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_read_enb_iddq_MASK |
+				BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_dqs_iddq_MASK |
+				BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_clk_iddq_MASK;
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL, regVal);
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL);
+
+	regVal |=	BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_idle_MASK |
+				BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_dm_iddq_MASK |
+				BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_dq_iddq_MASK |
+				BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_read_enb_iddq_MASK |
+				BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_dqs_iddq_MASK |
+				BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_clk_iddq_MASK;
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL, regVal);
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_CLOCK_REG_CONTROL);
+	regVal |= BCHP_DDR23_PHY_BYTE_LANE_0_CLOCK_REG_CONTROL_pwrdn_MASK;
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_CLOCK_REG_CONTROL, regVal);
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_CLOCK_REG_CONTROL);
+	regVal |= BCHP_DDR23_PHY_BYTE_LANE_1_CLOCK_REG_CONTROL_pwrdn_MASK;
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_CLOCK_REG_CONTROL, regVal);
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_IDLE_PAD_CONTROL);
+	regVal |=	BCHP_DDR23_PHY_CONTROL_REGS_IDLE_PAD_CONTROL_idle_MASK |
+				BCHP_DDR23_PHY_CONTROL_REGS_IDLE_PAD_CONTROL_ctl_iddq_MASK |
+				BCHP_DDR23_PHY_CONTROL_REGS_IDLE_PAD_CONTROL_rxenb_MASK |
+				BCHP_DDR23_PHY_CONTROL_REGS_IDLE_PAD_CONTROL_cke_reb_MASK;
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_IDLE_PAD_CONTROL, regVal);
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_CLK_PM_CTRL, BCHP_DDR23_PHY_CONTROL_REGS_CLK_PM_CTRL_DIS_DDR_CLK_MASK);
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG);
+	regVal |= BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG_PWRDN_MASK;
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG, regVal);
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_CLOCK_REG_CONTROL);
+	regVal |= BCHP_DDR23_PHY_CONTROL_REGS_CLOCK_REG_CONTROL_pwrdn_MASK;
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_CLOCK_REG_CONTROL, regVal);
+
+	/* Finally clock off the DRAM controller */
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_CLK_PM_CTRL);
+	regVal |=	BCHP_CLK_PM_CTRL_DIS_DDR_108_CLK_MASK |	BCHP_CLK_PM_CTRL_DIS_DDR_216_CLK_MASK;
+	hw->pfnWriteDevRegister(hw->adp, BCHP_CLK_PM_CTRL, regVal);
+
+	/* udelay(20); */
+
+	/*printk("RT Power Down Flea Complete\n"); */
+
+	/* Measure how much time we spend in idle */
+	rdtscll(hw->TickStartInPD);
+
+	return;
+}
+
+bool crystalhd_flea_detect_fw_alive(struct crystalhd_hw *hw)
+{
+	uint32_t pollCnt		= 0;
+	uint32_t hbCnt			= 0;
+	uint32_t heartBeatReg1	= 0;
+	uint32_t heartBeatReg2	= 0;
+	bool	 bRetVal		= false;
+
+	heartBeatReg1 = hw->pfnReadDevRegister(hw->adp, HEART_BEAT_REGISTER);
+	while(1)
+	{
+		heartBeatReg2 = hw->pfnReadDevRegister(hw->adp, HEART_BEAT_REGISTER);
+		if(heartBeatReg1 != heartBeatReg2) {
+			hbCnt++;
+			heartBeatReg1 = heartBeatReg2;
+		}
+
+		if(hbCnt >= HEART_BEAT_POLL_CNT) {
+			bRetVal = true;
+			break;
+		}
+
+		pollCnt++;
+		if(pollCnt >= FLEA_MAX_POLL_CNT) {
+			bRetVal = false;
+			break;
+		}
+
+		msleep_interruptible(1);
+	}
+
+	return bRetVal;
+}
+
+void crystalhd_flea_handle_PicQSts_intr(struct crystalhd_hw *hw)
+{
+	uint32_t	newChBitmap=0;
+
+	newChBitmap = hw->pfnReadDevRegister(hw->adp, RX_DMA_PIC_QSTS_MBOX);
+
+	hw->PicQSts = newChBitmap;
+
+	/* -- For link we were enabling the capture on format change
+	   -- For Flea, we will get a PicQSts interrupt where we will
+	   -- enable the capture. */
+
+	if(hw->RxCaptureState != 1)
+	{
+		hw->RxCaptureState = 1;
+	}
+}
+
+void crystalhd_flea_update_tx_buff_info(struct crystalhd_hw *hw)
+{
+	struct TX_INPUT_BUFFER_INFO	TxBuffInfo;
+	uint32_t ReadSzInDWords=0;
+
+	ReadSzInDWords = (sizeof(TxBuffInfo) - sizeof(TxBuffInfo.Reserved))/4;
+	hw->pfnDevDRAMRead(hw, hw->TxBuffInfoAddr, ReadSzInDWords, (uint32_t*)&TxBuffInfo);
+
+	if(TxBuffInfo.DramBuffAdd % 4)
+	{
+		printk("Tx Err:: DWORD UNAligned Tx Addr. Not Updating\n");
+		return;
+	}
+
+	hw->TxFwInputBuffInfo.DramBuffAdd			= TxBuffInfo.DramBuffAdd;
+	hw->TxFwInputBuffInfo.DramBuffSzInBytes		= TxBuffInfo.DramBuffSzInBytes;
+	hw->TxFwInputBuffInfo.Flags					= TxBuffInfo.Flags;
+	hw->TxFwInputBuffInfo.HostXferSzInBytes		= TxBuffInfo.HostXferSzInBytes;
+	hw->TxFwInputBuffInfo.SeqNum				= TxBuffInfo.SeqNum;
+
+	return;
+}
+
+/* was HWFleaNotifyFllChange */
+void crystalhd_flea_notify_fll_change(struct crystalhd_hw *hw, bool bCleanupContext)
+{
+	unsigned long flags = 0;
+	uint32_t freeListLen = 0;
+	/*
+	* When we are doing the cleanup we should update DRAM only if the
+	* firmware is running. So Detect the heart beat.
+	*/
+	if(bCleanupContext && (!crystalhd_flea_detect_fw_alive(hw)))
+		return;
+
+	spin_lock_irqsave(&hw->lock, flags);
+	freeListLen = crystalhd_dioq_count(hw->rx_freeq);
+	hw->pfnDevDRAMWrite(hw, hw->FleaFLLUpdateAddr, 1, &freeListLen);
+	spin_unlock_irqrestore(&hw->lock, flags);
+
+	return;
+}
+
+
+static
+void crystalhd_flea_init_power_state(struct crystalhd_hw *hw)
+{
+	hw->FleaEnablePWM = false;	/* enable by default */
+	hw->FleaPowerState = FLEA_PS_NONE;
+}
+
+static
+bool crystalhd_flea_set_power_state(struct crystalhd_hw *hw,
+					enum FLEA_POWER_STATES	NewState)
+{
+	bool StChangeSuccess=false;
+	uint32_t tempFLL = 0;
+	uint32_t freeListLen = 0;
+	enum BC_STATUS sts;
+	struct crystalhd_rx_dma_pkt *rx_pkt = NULL;
+
+	freeListLen = crystalhd_dioq_count(hw->rx_freeq);
+
+	switch(NewState)
+	{
+		case FLEA_PS_ACTIVE:
+		{
+			/*Transition to Active State*/
+			if(hw->FleaPowerState == FLEA_PS_LP_PENDING)
+			{
+				StChangeSuccess = true;
+				hw->FleaPowerState = FLEA_PS_ACTIVE;
+				/* Write the correct FLL to FW */
+				hw->pfnDevDRAMWrite(hw,
+									hw->FleaFLLUpdateAddr,
+									1,
+									&freeListLen);
+				/* We need to check to post here because we may never get a context to post otherwise */
+				if(hw->PicQSts != 0)
+				{
+					rx_pkt = crystalhd_dioq_fetch(hw->rx_freeq);
+					if (rx_pkt)
+						sts = hw->pfnPostRxSideBuff(hw, rx_pkt);
+				}
+				/*printk(" Success\n"); */
+
+			}else if(hw->FleaPowerState == FLEA_PS_LP_COMPLETE){
+				crystalhd_flea_runtime_power_up(hw);
+				StChangeSuccess = true;
+				hw->FleaPowerState = FLEA_PS_ACTIVE;
+				/* Write the correct FLL to FW */
+				hw->pfnDevDRAMWrite(hw,
+										hw->FleaFLLUpdateAddr,
+										1,
+										&freeListLen);
+				/* Now check if we missed processing PiQ and TXFIFO interrupts when we were in power down */
+				if (hw->PwrDwnPiQIntr)
+				{
+					crystalhd_flea_handle_PicQSts_intr(hw);
+					hw->PwrDwnPiQIntr = false;
+				}
+				/* We need to check to post here because we may never get a context to post otherwise */
+				if(hw->PicQSts != 0)
+				{
+					rx_pkt = crystalhd_dioq_fetch(hw->rx_freeq);
+					if (rx_pkt)
+						sts = hw->pfnPostRxSideBuff(hw, rx_pkt);
+				}
+				if (hw->PwrDwnTxIntr)
+				{
+					crystalhd_flea_update_tx_buff_info(hw);
+					hw->PwrDwnTxIntr = false;
+				}
+
+			}
+			break;
+		}
+
+		case FLEA_PS_LP_PENDING:
+		{
+			if(hw->FleaPowerState != FLEA_PS_ACTIVE)
+			{
+				break;
+			}
+
+			/*printk(" Success\n"); */
+
+			StChangeSuccess = true;
+			/* Write 0 FLL to FW to prevent it from sending PQ*/
+			hw->pfnDevDRAMWrite(hw,
+									hw->FleaFLLUpdateAddr,
+									1,
+									&tempFLL);
+			hw->FleaPowerState = FLEA_PS_LP_PENDING;
+			break;
+		}
+
+		case FLEA_PS_LP_COMPLETE:
+		{
+			if( (hw->FleaPowerState == FLEA_PS_ACTIVE) ||
+			    (hw->FleaPowerState == FLEA_PS_LP_PENDING)) {
+				/* Write 0 FLL to FW to prevent it from sending PQ*/
+				hw->pfnDevDRAMWrite(hw,
+									hw->FleaFLLUpdateAddr,
+									1,
+									&tempFLL);
+				crystalhd_flea_runtime_power_dn(hw);
+				StChangeSuccess = true;
+				hw->FleaPowerState = FLEA_PS_LP_COMPLETE;
+
+			}
+			break;
+		}
+		default:
+			break;
+	}
+
+	return StChangeSuccess;
+}
+
+/*
+* Look At Different States and List Status and decide on
+* Next Logical State To Be In.
+*/
+static
+void crystalhd_flea_set_next_power_state(struct crystalhd_hw *hw,
+						enum FLEA_STATE_CH_EVENT		PowerEvt)
+{
+	enum FLEA_POWER_STATES NextPS;
+	NextPS = hw->FleaPowerState;
+
+	if( hw->FleaEnablePWM == false )
+	{
+		hw->FleaPowerState = FLEA_PS_ACTIVE;
+		return;
+	}
+
+/*	printk("Trying Power State Transition from %x Because Of Event:%d \n", */
+/*			hw->FleaPowerState, */
+/*			PowerEvt); */
+
+	if(PowerEvt == FLEA_EVT_STOP_DEVICE)
+	{
+		hw->FleaPowerState = FLEA_PS_STOPPED;
+		return;
+	}
+
+	if(PowerEvt == FLEA_EVT_START_DEVICE)
+	{
+		hw->FleaPowerState = FLEA_PS_ACTIVE;
+		return;
+	}
+
+	switch(hw->FleaPowerState)
+	{
+		case FLEA_PS_ACTIVE:
+		{
+			if(PowerEvt == FLEA_EVT_FLL_CHANGE)
+			{
+				/*Ready List Was Decremented. */
+				/*printk("1:TxL0Sts:%x TxL1Sts:%x EmptyCnt:%x RxL0Sts:%x RxL1Sts:%x FwCmdCnt:%x\n", */
+				/*	hw->TxList0Sts, */
+				/*	hw->TxList1Sts, */
+				/*	hw->EmptyCnt, */
+				/*	hw->rx_list_sts[0], */
+				/*	hw->rx_list_sts[1], */
+				/*	hw->FwCmdCnt); */
+
+				if( (hw->TxList0Sts == ListStsFree)	&&
+					(hw->TxList1Sts == ListStsFree) &&
+					(!hw->EmptyCnt) && /*We have Not Indicated Any Empty Fifo to Application*/
+					(!hw->SingleThreadAppFIFOEmpty) && /*for single threaded apps*/
+					(!(hw->rx_list_sts[0] && rx_waiting_y_intr)) &&
+					(!(hw->rx_list_sts[1] && rx_waiting_y_intr)) &&
+					(!hw->FwCmdCnt))
+				{
+					NextPS = FLEA_PS_LP_COMPLETE;
+				}else{
+					NextPS = FLEA_PS_LP_PENDING;
+				}
+			}
+
+			break;
+		}
+
+		case FLEA_PS_LP_PENDING:
+		{
+			if( (PowerEvt == FLEA_EVT_FW_CMD_POST) ||
+				(PowerEvt == FLEA_EVT_FLL_CHANGE))
+			{
+				NextPS = FLEA_PS_ACTIVE;
+			}else if(PowerEvt == FLEA_EVT_CMD_COMP){
+
+				/*printk("2:TxL0Sts:%x TxL1Sts:%x EmptyCnt:%x STAppFIFOEmpty:%x RxL0Sts:%x RxL1Sts:%x FwCmdCnt:%x\n", */
+				/*	hw->TxList0Sts, */
+				/*	hw->TxList1Sts, */
+				/*	hw->EmptyCnt, */
+				/*	hw->SingleThreadAppFIFOEmpty, */
+				/*	hw->rx_list_sts[0], */
+				/*	hw->rx_list_sts[1], */
+				/*	hw->FwCmdCnt); */
+
+				if( (hw->TxList0Sts == ListStsFree)	&&
+					(hw->TxList1Sts == ListStsFree) &&
+					(!hw->EmptyCnt) &&	/*We have Not Indicated Any Empty Fifo to Application*/
+					(!hw->SingleThreadAppFIFOEmpty) && /*for single threaded apps*/
+					(!(hw->rx_list_sts[0] && rx_waiting_y_intr)) &&
+					(!(hw->rx_list_sts[1] && rx_waiting_y_intr)) &&
+					(!hw->FwCmdCnt))
+				{
+					NextPS = FLEA_PS_LP_COMPLETE;
+				}
+			}
+			break;
+		}
+		case FLEA_PS_LP_COMPLETE:
+		{
+			if( (PowerEvt == FLEA_EVT_FLL_CHANGE) ||
+				(PowerEvt == FLEA_EVT_FW_CMD_POST))
+			{
+				NextPS = FLEA_PS_ACTIVE;
+			}
+
+			break;
+		}
+		default:
+		{
+			printk("Invalid Flea Power State %x\n",
+				hw->FleaPowerState);
+
+			break;
+		}
+	}
+
+	if(hw->FleaPowerState != NextPS)
+	{
+		printk("%s:State Transition [FromSt:%x ToSt:%x] Because Of Event:%d \n",
+			__FUNCTION__,
+			hw->FleaPowerState,
+			NextPS,
+			PowerEvt);
+
+		crystalhd_flea_set_power_state(hw,NextPS);
+	}
+
+	return;
+}
+
+/* was FleaSetRxPicFireAddr */
+#if 0
+static
+void crystalhd_flea_set_rx_pic_fire_addr(struct crystalhd_hw *hw, uint32_t BorshContents)
+{
+	hw->FleaRxPicDelAddr = BorshContents + 1 + HOST_TO_FW_PIC_DEL_INFO_ADDR;
+	hw->FleaFLLUpdateAddr = BorshContents + 1 + HOST_TO_FW_FLL_ADDR;
+
+	return;
+}
+#endif
+
+void crystalhd_flea_init_temperature_measure (struct crystalhd_hw *hw, bool bTurnOn)
+{
+	hw->TemperatureRegVal=0;
+
+	if(bTurnOn) {
+		hw->pfnWriteDevRegister(hw->adp, BCHP_CLK_TEMP_MON_CTRL, 0x3);
+		hw->pfnWriteDevRegister(hw->adp, BCHP_CLK_TEMP_MON_CTRL, 0x203);
+	} else {
+		hw->pfnWriteDevRegister(hw->adp, BCHP_CLK_TEMP_MON_CTRL, 0x103);
+	}
+
+	return;
+}
+
+/* was HwFleaUpdateTempInfo */
+void crystalhd_flea_update_temperature(struct crystalhd_hw *hw)
+{
+	uint32_t	regVal = 0;
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_CLK_TEMP_MON_STATUS);
+	hw->TemperatureRegVal = regVal;
+
+	return;
+}
+
+/**
+* crystalhd_flea_download_fw - Write data to DRAM area.
+* @adp: Adapter instance
+* @pBuffer: Buffer pointer for the FW data.
+* @buffSz: data size in bytes.
+*
+* Return:
+*	Status.
+*
+* Flea firmware download routine.
+*/
+enum BC_STATUS crystalhd_flea_download_fw(struct crystalhd_hw *hw, uint8_t *pBuffer, uint32_t buffSz)
+{
+	uint32_t pollCnt=0,regVal=0;
+	uint32_t borchStachAddr=0;
+	uint32_t *pCmacSig=NULL,cmacOffset=0,i=0;
+	/*uint32_t BuffSz = (BuffSzInDWords * 4); */
+	/*uint32_t HBCnt=0; */
+
+	bool bRetVal = true;
+	bool bSecure = true; // Default production cards. Can be false only for internal Broadcom dev cards
+
+	dev_dbg(&hw->adp->pdev->dev, "[%s]: Sz:%d\n", __func__, buffSz);
+
+/*
+ *-- Step 1. Enable the SRCUBBING and DRAM SCRAMBLING
+ *-- Step 2. Poll for SCRAM_KEY_DONE_INT.
+ *-- Step 3. Write the BORCH and STARCH addresses.
+ *-- Step 4. Write the firmware to DRAM.
+ *-- Step 5. Write the CMAC to SCRUB->CMAC registers.
+ *-- Step 6. Write the ARM run bit to 1.
+ *-- Step 7. Poll for BOOT verification done interrupt.
+ */
+
+	/* First validate that we got data in the FW buffer */
+	if (buffSz == 0)
+		return BC_STS_ERROR;
+
+/*-- Step 1. Enable the SRCUBBING and DRAM SCRAMBLING. */
+/*   Can we set both the bits at the same time?? Security Arch Doc describes the steps */
+/*   and the first step is to enable scrubbing and then scrambling. */
+
+	if(bSecure)
+	{
+		dev_dbg(&hw->adp->pdev->dev,"[crystalhd_flea_download_fw]: step 1. Enable scrubbing\n");
+
+		/* Enable Scrubbing */
+		regVal = hw->pfnReadDevRegister(hw->adp, BCHP_SCRUB_CTRL_SCRUB_ENABLE);
+		regVal |= SCRUB_ENABLE_BIT;
+		hw->pfnWriteDevRegister(hw->adp, BCHP_SCRUB_CTRL_SCRUB_ENABLE, regVal);
+
+		/* Enable Scrambling */
+		regVal |= DRAM_SCRAM_ENABLE_BIT;
+		hw->pfnWriteDevRegister(hw->adp, BCHP_SCRUB_CTRL_SCRUB_ENABLE, regVal);
+
+
+		//-- Step 2. Poll for SCRAM_KEY_DONE_INT.
+		dev_dbg(&hw->adp->pdev->dev,"[crystalhd_flea_download_fw]: step 2. Poll for SCRAM_KEY_DONE_INT\n");
+
+		pollCnt=0;
+		while(pollCnt < FLEA_MAX_POLL_CNT)
+		{
+			regVal = hw->pfnReadDevRegister(hw->adp, BCHP_WRAP_MISC_INTR2_PCI_STATUS);
+
+			if(regVal & SCRAM_KEY_DONE_INT_BIT)
+				break;
+
+			pollCnt++;
+			msleep_interruptible(1); /*1 Milli Sec delay*/
+		}
+
+		/* -- Will Assert when we do not see SCRAM_KEY_DONE_INTERRUPT */
+		if(!(regVal & SCRAM_KEY_DONE_INT_BIT))
+		{
+			dev_err(&hw->adp->pdev->dev,"[crystalhd_flea_download_fw]: step 2. Did not get scram key done interrupt.\n");
+			return BC_STS_ERROR;
+		}
+	}
+
+	/*Clear the interrupts by writing the register value back*/
+	regVal &= 0x00FFFFFF; /*Mask off the reserved bits.[24-31] */
+	hw->pfnWriteDevRegister(hw->adp, BCHP_WRAP_MISC_INTR2_PCI_CLEAR, regVal);
+
+/*-- Step 3. Write the BORCH and STARCH addresses. */
+	borchStachAddr = GetScrubEndAddr(buffSz);
+	if(!bSecure)
+		borchStachAddr = (buffSz - 1) & BCHP_SCRUB_CTRL_BORCH_END_ADDRESS_BORCH_END_ADDR_MASK;
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_SCRUB_CTRL_BORCH_END_ADDRESS, borchStachAddr);
+	hw->pfnWriteDevRegister(hw->adp, BCHP_SCRUB_CTRL_STARCH_END_ADDRESS, borchStachAddr);
+
+	/*
+	 *	Now the command address is
+	 *	relative to firmware file size.
+	 */
+	/*FWIFSetFleaCmdAddr(pHWExt->pFwExt, */
+	/*		borchStachAddr+1+DDRADDR_4_FWCMDS); */
+
+	hw->fwcmdPostAddr = borchStachAddr+1+DDRADDR_4_FWCMDS;
+	hw->fwcmdPostMbox = FW_CMD_POST_MBOX;
+	hw->fwcmdRespMbox = FW_CMD_RES_MBOX;
+	/*FleaSetRxPicFireAddr(pHWExt,borchStachAddr); */
+	hw->FleaRxPicDelAddr = borchStachAddr + 1 + HOST_TO_FW_PIC_DEL_INFO_ADDR;
+	hw->FleaFLLUpdateAddr = borchStachAddr + 1 + HOST_TO_FW_FLL_ADDR;
+
+	dev_dbg(&hw->adp->pdev->dev,"[crystalhd_flea_download_fw]: step 3. Write the BORCH and STARCH addresses. %x:%x, %x:%x\n",
+			BCHP_SCRUB_CTRL_BORCH_END_ADDRESS,
+			borchStachAddr,
+			BCHP_SCRUB_CTRL_STARCH_END_ADDRESS,
+			borchStachAddr );
+
+/*-- Step 4. Write the firmware to DRAM. [Without the Signature, 32-bit access to DRAM] */
+
+	dev_dbg(&hw->adp->pdev->dev,"[crystalhd_flea_download_fw]: step 4. Write the firmware to DRAM. Sz:%d Bytes\n",
+			buffSz - FLEA_FW_SIG_LEN_IN_BYTES - LENGTH_FIELD_SIZE);
+
+	if(bSecure)
+		hw->pfnDevDRAMWrite(hw, FW_DOWNLOAD_START_ADDR, (buffSz - FLEA_FW_SIG_LEN_IN_BYTES - LENGTH_FIELD_SIZE)/4, (uint32_t *)pBuffer);
+	else
+		hw->pfnDevDRAMWrite(hw, FW_DOWNLOAD_START_ADDR, buffSz/4, (uint32_t*)pBuffer);
+
+/* -- Step 5. Write the signature to CMAC register. */
+/*
+-- This is what we need to write to CMAC registers.
+==================================================================================
+Register							Offset				Boot Image CMAC
+														Value
+==================================================================================
+BCHP_SCRUB_CTRL_BI_CMAC_31_0		0x000f600c			CMAC Bits[31:0]
+BCHP_SCRUB_CTRL_BI_CMAC_63_32		0x000f6010			CMAC Bits[63:32]
+BCHP_SCRUB_CTRL_BI_CMAC_95_64		0x000f6014			CMAC Bits[95:64]
+BCHP_SCRUB_CTRL_BI_CMAC_127_96		0x000f6018			CMAC Bits[127:96]
+==================================================================================
+*/
+
+	if(bSecure)
+	{
+		dev_dbg(&hw->adp->pdev->dev,"[crystalhd_flea_download_fw]: step 5. Write the signature to CMAC register.\n");
+		cmacOffset = buffSz - FLEA_FW_SIG_LEN_IN_BYTES;
+		pCmacSig = (uint32_t *) &pBuffer[cmacOffset];
+
+		for(i=0;i < FLEA_FW_SIG_LEN_IN_DWORD;i++)
+		{
+			uint32_t offSet = (BCHP_SCRUB_CTRL_BI_CMAC_127_96 - (i * 4));
+
+			hw->pfnWriteDevRegister(hw->adp, offSet, cpu_to_be32(*pCmacSig));
+
+			pCmacSig++;
+		}
+	}
+
+/*-- Step 6. Write the ARM run bit to 1. */
+/*   We need a write back because we do not want to change other bits */
+	dev_dbg(&hw->adp->pdev->dev,"[crystalhd_flea_download_fw]: step 6. Write the ARM run bit to 1.\n");
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_ARMCR4_BRIDGE_REG_BRIDGE_CTL);
+	regVal |= ARM_RUN_REQ_BIT;
+	hw->pfnWriteDevRegister(hw->adp, BCHP_ARMCR4_BRIDGE_REG_BRIDGE_CTL, regVal);
+
+	if(bSecure)
+	{
+		/* -- Step 7. Poll for Boot Verification done/failure interrupt.*/
+		dev_dbg(&hw->adp->pdev->dev,"[crystalhd_flea_download_fw]: step 7. Poll for Boot Verification done/failure interrupt.\n");
+		pollCnt=0;
+		while(1)
+		{
+			regVal = hw->pfnReadDevRegister(hw->adp, BCHP_WRAP_MISC_INTR2_PCI_STATUS);
+
+			if(regVal & BOOT_VER_FAIL_BIT )
+			{
+				dev_err(&hw->adp->pdev->dev,"[crystalhd_flea_download_fw]: step 7. Error bit occured. RetVal:%x\n", regVal);
+
+				bRetVal = false;
+				break;
+			}
+
+			if(regVal & BOOT_VER_DONE_BIT)
+			{
+				dev_dbg(&hw->adp->pdev->dev,"[crystalhd_flea_download_fw]: step 7. Done  RetVal:%x\n", regVal);
+
+				bRetVal = true; /*This is the only place we return TRUE from*/
+				break;
+			}
+
+			pollCnt++;
+			if( pollCnt >= FLEA_MAX_POLL_CNT )
+			{
+				dev_err(&hw->adp->pdev->dev,"[crystalhd_flea_download_fw]: step 7. Both done and failure bits are not set.\n");
+				bRetVal = false;
+				break;
+			}
+
+			msleep_interruptible(5); /*5 Milli Sec delay*/
+		}
+
+		if( !bRetVal )
+		{
+			dev_info(&hw->adp->pdev->dev,"[crystalhd_flea_download_fw]: step 7. Firmware image signature failure.\n");
+			return BC_STS_ERROR;
+		}
+
+		/*Clear the interrupts by writing the register value back*/
+		regVal &= 0x00FFFFFF; //Mask off the reserved bits.[24-31]
+		hw->pfnWriteDevRegister(hw->adp, BCHP_WRAP_MISC_INTR2_PCI_CLEAR, regVal);
+
+		msleep_interruptible(10); /*10 Milli Sec delay*/
+	}
+	else
+		bRetVal = true;
+
+	/*
+	   -- It was seen on Dell390 systems that the firmware command was fired before the
+	   -- firmware was actually ready to accept the firmware commands. The driver did
+	   -- not recieve a response for the firmware commands and this was causing the DIL to timeout
+	   -- ,reclaim the resources and crash. The following code looks for the heartbeat and
+	   -- to make sure that we return from this function only when we get the heart beat making sure
+	   -- that the firmware is running.
+	   */
+
+	bRetVal = crystalhd_flea_detect_fw_alive(hw);
+	if( !bRetVal )
+	{
+		dev_info(&hw->adp->pdev->dev,"[crystalhd_flea_download_fw]: step 8. Detect firmware heart beat failed.\n");
+		return BC_STS_ERROR;
+	}
+
+	dev_dbg(&hw->adp->pdev->dev, "[%s]: Complete.\n", __func__);
+	return BC_STS_SUCCESS;
+}
+
+bool crystalhd_flea_start_device(struct crystalhd_hw *hw)
+{
+	uint32_t	regVal	= 0;
+	bool		bRetVal = false;
+
+	/*
+	-- Issue Core reset to bring in the default values in place
+	*/
+	crystalhd_flea_core_reset(hw);
+
+	/*
+	-- If the gisb arbitar register is not set to some other value
+	-- and the firmware crashes, we see a NMI since the hardware did
+	-- not respond to a register read at all. The PCI-E trace confirms the problem.
+	-- Right now we are setting the register values to 0x7e00 and will check later
+	-- what should be the correct value to program.
+	*/
+	hw->pfnWriteDevRegister(hw->adp, BCHP_SUN_GISB_ARB_TIMER, 0xd80);
+
+	/*
+	-- Disable all interrupts
+	*/
+	crystalhd_flea_clear_interrupts(hw);
+	crystalhd_flea_disable_interrupts(hw);
+
+	/*
+	-- Enable the option for getting the done count in
+	-- Rx DMA engine.
+	*/
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_MISC1_DMA_DEBUG_OPTIONS_REG);
+	regVal |= 0x10;
+	hw->pfnWriteDevRegister(hw->adp, BCHP_MISC1_DMA_DEBUG_OPTIONS_REG, regVal);
+
+	/*
+	-- Enable the TX DMA Engine once on startup.
+	-- This is a new bit added.
+	*/
+	hw->pfnWriteDevRegister(hw->adp, BCHP_MISC1_TX_DMA_CTRL, 0x01);
+
+	/*
+	-- Enable the RX3 DMA Engine once on startup.
+	-- This is a new bit added.
+	*/
+	hw->pfnWriteDevRegister(hw->adp, BCHP_MISC1_HIF_DMA_CTRL, 0x01);
+
+	/*
+	-- Set the Run bit for RX-Y and RX-UV DMA engines.
+	*/
+	hw->pfnWriteDevRegister(hw->adp, BCHP_MISC1_Y_RX_SW_DESC_LIST_CTRL_STS, 0x01);
+
+	/*
+	-- Make sure Early L1 is disabled - NAREN - This will not prevent the device from entering L1 under active mode
+	*/
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_MISC_PERST_CLOCK_CTRL);
+	regVal &= ~BCHP_MISC_PERST_CLOCK_CTRL_EARLY_L1_EXIT_MASK;
+	hw->pfnWriteDevRegister(hw->adp, BCHP_MISC_PERST_CLOCK_CTRL, regVal);
+
+	crystalhd_flea_init_dram(hw);
+
+	msleep_interruptible(5);
+
+	/* Enable the Single Shot Transaction on PCI by disabling the */
+	/* bit 29 of transaction configuration register */
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_PCIE_TL_TRANSACTION_CONFIGURATION);
+	regVal &= (~(BC_BIT(29)));
+	hw->pfnWriteDevRegister(hw->adp, BCHP_PCIE_TL_TRANSACTION_CONFIGURATION, regVal);
+
+	crystalhd_flea_init_temperature_measure(hw,true);
+
+	crystalhd_flea_init_power_state(hw);
+	crystalhd_flea_set_next_power_state(hw, FLEA_EVT_START_DEVICE);
+
+	/*
+	-- Enable all interrupts
+	*/
+	crystalhd_flea_clear_interrupts(hw);
+	crystalhd_flea_enable_interrupts(hw);
+
+	/*
+	-- This is the only time we set this pointer for Flea.
+	-- Since there is no stop the pointer is not reset anytime....
+	-- except for fatal errors.
+	*/
+	hw->rx_list_post_index = 0;
+	hw->RxCaptureState = 0;
+
+	msleep_interruptible(1);
+
+	return bRetVal;
+}
+
+
+bool crystalhd_flea_stop_device(struct crystalhd_hw *hw)
+{
+	uint32_t regVal=0, pollCnt=0;
+
+	/*
+	-- Issue the core reset so that we
+	-- make sure there is nothing running.
+	*/
+	crystalhd_flea_core_reset(hw);
+
+	crystalhd_flea_init_temperature_measure(hw, false);
+
+	/*
+	-- If the gisb arbitrater register is not set to some other value
+	-- and the firmware crashes, we see a NMI since the hardware did
+	-- not respond to a register read at all. The PCI-E trace confirms the problem.
+	-- Right now we are setting the register values to 0x7e00 and will check later
+	-- what should be the correct value to program.
+	*/
+	hw->pfnWriteDevRegister(hw->adp, BCHP_SUN_GISB_ARB_TIMER, 0xd80);
+
+	/*
+	-- Disable the TX DMA Engine once on shutdown.
+	-- This is a new bit added.
+	*/
+	hw->pfnWriteDevRegister(hw->adp, BCHP_MISC1_TX_DMA_CTRL, 0x0);
+
+	/*
+	-- Disable the RX3 DMA Engine once on Stop.
+	-- This is a new bit added.
+	*/
+	hw->pfnWriteDevRegister(hw->adp, BCHP_MISC1_HIF_DMA_CTRL, 0x0);
+
+	/*
+	-- Clear the RunStop Bit For RX DMA Control
+	*/
+	hw->pfnWriteDevRegister(hw->adp, BCHP_MISC1_Y_RX_SW_DESC_LIST_CTRL_STS, 0x0);
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_PRI_ARB_CONTROL_REGS_REFRESH_CTL_0, 0x0);
+
+	/* * Wait for MEMC to become idle */
+	pollCnt=0;
+	while (1)
+	{
+		regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_CTL_STATUS);
+
+		if(regVal & BCHP_DDR23_CTL_REGS_0_CTL_STATUS_idle_MASK)
+			break;
+
+		pollCnt++;
+		if(pollCnt >= 100)
+			break;
+
+		msleep_interruptible(1);
+	}
+
+	/*First Disable the AVD and ARM before disabling the DRAM*/
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_CLK_PM_CTRL);
+
+	regVal = BCHP_CLK_PM_CTRL_DIS_ARM_CLK_MASK |
+			 BCHP_CLK_PM_CTRL_DIS_AVD_CLK_MASK |
+			 BCHP_CLK_PM_CTRL_DIS_AVD_108_CLK_MASK |
+			 BCHP_CLK_PM_CTRL_DIS_AVD_216_CLK_MASK;
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_CLK_PM_CTRL, regVal);
+
+	/*
+	-- Disable the interrupt after disabling the ARM and AVD.
+	-- We should be able to access the registers because we still
+	-- have not disabled the clock for blink block. We disable the
+	-- blick 108 abd 216 clock at the end of this function.
+	*/
+	crystalhd_flea_clear_interrupts(hw);
+	crystalhd_flea_disable_interrupts(hw);
+
+	/*Now try disabling the DRAM.*/
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_PARAMS2);
+
+	regVal |= BCHP_DDR23_CTL_REGS_0_PARAMS2_clke_MASK;
+
+	/* * disable CKE */
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_PARAMS2, regVal);
+
+	/* * issue refresh command */
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_REFRESH_CMD, 0x60);
+
+	pollCnt=0;
+	while(1)
+	{
+		regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_CTL_REGS_0_CTL_STATUS);
+
+		if(!(regVal & BCHP_DDR23_CTL_REGS_0_CTL_STATUS_clke_MASK))
+			break;
+
+		pollCnt++;
+		if(pollCnt >= 100)
+			break;
+
+		msleep_interruptible(1);
+	}
+
+	/* * Enable DDR clock, DM and READ_ENABLE pads power down and force into the power down */
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL,
+							BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_idle_MASK |
+							BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_dm_iddq_MASK |
+							BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_dq_iddq_MASK |
+							BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_read_enb_iddq_MASK |
+							BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_dqs_iddq_MASK |
+							BCHP_DDR23_PHY_BYTE_LANE_0_IDLE_PAD_CONTROL_clk_iddq_MASK);
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL,
+							BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_idle_MASK |
+							BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_dm_iddq_MASK |
+							BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_dq_iddq_MASK |
+							BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_read_enb_iddq_MASK |
+							BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_dqs_iddq_MASK |
+							BCHP_DDR23_PHY_BYTE_LANE_1_IDLE_PAD_CONTROL_clk_iddq_MASK);
+
+	/* * Power down BL LDO cells */
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_0_CLOCK_REG_CONTROL,
+							BCHP_DDR23_PHY_BYTE_LANE_0_CLOCK_REG_CONTROL_pwrdn_MASK);
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_BYTE_LANE_1_CLOCK_REG_CONTROL,
+							BCHP_DDR23_PHY_BYTE_LANE_1_CLOCK_REG_CONTROL_pwrdn_MASK);
+
+	/* * Enable DDR control signal pad power down and force into the power down */
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_IDLE_PAD_CONTROL,
+							BCHP_DDR23_PHY_CONTROL_REGS_IDLE_PAD_CONTROL_idle_MASK |
+							BCHP_DDR23_PHY_CONTROL_REGS_IDLE_PAD_CONTROL_ctl_iddq_MASK);
+
+	/* * Disable ddr phy clock */
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_CLK_PM_CTRL,
+							BCHP_DDR23_PHY_CONTROL_REGS_CLK_PM_CTRL_DIS_DDR_CLK_MASK);
+
+	/* * Disable PLL output */
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG);
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG,
+							regVal & ~BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG_ENB_CLKOUT_MASK);
+
+	/* * Power down addr_ctl LDO cells */
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_CLOCK_REG_CONTROL,
+							BCHP_DDR23_PHY_CONTROL_REGS_CLOCK_REG_CONTROL_pwrdn_MASK);
+
+	/* * Power down the PLL */
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG);
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG,
+							regVal | BCHP_DDR23_PHY_CONTROL_REGS_PLL_CONFIG_PWRDN_MASK);
+
+	/* shut down the PLL1 */
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_CLK_PLL1_CTRL);
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_CLK_PLL1_CTRL,
+							regVal | BCHP_CLK_PLL1_CTRL_POWERDOWN_MASK);
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_CLK_PLL0_ARM_DIV,	0xff);
+
+	regVal = hw->pfnReadDevRegister(hw->adp, BCHP_CLK_PM_CTRL);
+
+	regVal |= BCHP_CLK_PM_CTRL_DIS_SUN_27_LOW_PWR_MASK |
+			  BCHP_CLK_PM_CTRL_DIS_SUN_108_LOW_PWR_MASK |
+			  BCHP_CLK_PM_CTRL_DIS_MISC_OTP_9_CLK_MASK |
+			  BCHP_CLK_PM_CTRL_DIS_ARM_CLK_MASK |
+			  BCHP_CLK_PM_CTRL_DIS_AVD_CLK_MASK |
+			  BCHP_CLK_PM_CTRL_DIS_AVD_108_CLK_MASK |
+			  BCHP_CLK_PM_CTRL_DIS_BLINK_108_CLK_MASK |
+			  BCHP_CLK_PM_CTRL_DIS_MISC_108_CLK_MASK |
+			  BCHP_CLK_PM_CTRL_DIS_BLINK_216_CLK_MASK |
+			  BCHP_CLK_PM_CTRL_DIS_DDR_108_CLK_MASK |
+			  BCHP_CLK_PM_CTRL_DIS_DDR_216_CLK_MASK |
+			  BCHP_CLK_PM_CTRL_DIS_AVD_216_CLK_MASK |
+			  BCHP_CLK_PM_CTRL_DIS_MISC_216_CLK_MASK |
+			  BCHP_CLK_PM_CTRL_DIS_SUN_216_CLK_MASK;
+
+	hw->pfnWriteDevRegister(hw->adp, BCHP_CLK_PM_CTRL, regVal);
+
+	crystalhd_flea_set_next_power_state(hw, FLEA_EVT_STOP_DEVICE);
+	return true;
+}
+
+bool
+crystalhd_flea_wake_up_hw(struct crystalhd_hw *hw)
+{
+	if(hw->FleaPowerState != FLEA_PS_ACTIVE)
+	{
+		crystalhd_flea_set_next_power_state(hw,	FLEA_EVT_FLL_CHANGE);
+	}
+
+	/* Now notify HW of the number of entries in the Free List */
+	/* This starts up the channel bitmap delivery */
+	crystalhd_flea_notify_fll_change(hw, false);
+
+	hw->WakeUpDecodeDone = true;
+
+	return true;
+}
+
+bool crystalhd_flea_check_input_full(struct crystalhd_hw *hw, uint32_t needed_sz, uint32_t *empty_sz, bool b_188_byte_pkts, uint8_t *flags)
+{
+	uint32_t				regVal=0;
+	struct TX_INPUT_BUFFER_INFO	*pTxBuffInfo;
+	uint32_t				FlagsAddr=0;
+
+	*empty_sz = 0;
+/*	*DramAddrOut=0; */
+
+
+	/* Add condition here to wake up the HW in case some application is trying to do TX before starting RX - like FP */
+	/* To prevent deadlocks. We are called here from Synchronized context so we can safely call this directly */
+
+	if(hw->WakeUpDecodeDone != true)
+	{
+		/* Only wake up the HW if we are either being called from a single threaded app - like FP */
+		/* or if we are not checking for the input buffer size as just a test */
+		if(*flags == 0)
+			crystalhd_flea_wake_up_hw(hw);
+		else {
+			*empty_sz = 2 * 1024 * 1024; /* FW Buffer size */
+			/**DramAddrOut=0; */
+			*flags=0;
+			return false;
+		}
+	}
+
+	/* if we have told the app that we have buffer empty then we cannot go to low power */
+	if((hw->FleaPowerState != FLEA_PS_ACTIVE) && !hw->SingleThreadAppFIFOEmpty)
+	{
+		/**TxBuffSzOut=0; */
+		/**DramAddrOut=0; */
+		*empty_sz = 0;
+		*flags=0;
+		/*printk("PD can't Tx\n"); */
+		return true; /*Indicate FULL*/
+	}
+
+
+	if(hw->TxFwInputBuffInfo.Flags & DFW_FLAGS_TX_ABORT)
+	{
+		*empty_sz=0;
+		/**DramAddrOut=0; */
+		*flags |= DFW_FLAGS_TX_ABORT;
+		return true;
+	}
+
+	if( (hw->TxFwInputBuffInfo.DramBuffSzInBytes < needed_sz)
+		||(!hw->TxFwInputBuffInfo.DramBuffAdd))
+	{
+		*empty_sz=0;
+		/**DramAddrOut=0; */
+		*flags=0;
+		return true; /*Indicate FULL*/
+	}
+
+	if(hw->TxFwInputBuffInfo.DramBuffAdd % 4)
+	{
+		/*
+		-- Indicate Full if we get a non-dowrd aligned address.
+		-- This will avoid us posting the command to firmware and
+		-- The TX will timeout and we will close the application properly.
+		-- This avoids a illegal operation as far as the TX is concerned.
+		*/
+		printk("TxSDRAM-Destination Address Not DWORD Aligned:%x\n",hw->TxFwInputBuffInfo.DramBuffAdd);
+		return true;
+	}
+
+	/*
+	-- We got everything correctly from the firmware and hence we should be
+	-- able to do the DMA. Indicate what app wants to hear.
+	-- Firmware SAYS: I AM HUNGRY, GIVE ME FOOD. :)
+	*/
+	*empty_sz=hw->TxFwInputBuffInfo.DramBuffSzInBytes;
+	/**dramAddrOut=pHWExt->TxFwInputBuffInfo.DramBuffAdd; */
+/*	printk("empty size is %d\n", *empty_sz); */
+
+	/* If we are just checking stats and are not actually going to DMA, don't increment */
+	/* But we have to account for single threaded apps */
+	if((*flags & 0x08) == 0x08)
+	{
+		/* This is a synchronized function */
+		/* NAREN - In single threaded mode, if we have less than a defined size of buffer */
+		/* ask the firmware to wrap around. To prevent deadlocks. */
+		if(hw->TxFwInputBuffInfo.DramBuffSzInBytes < TX_WRAP_THRESHOLD)
+		{
+			pTxBuffInfo = (struct TX_INPUT_BUFFER_INFO *) (0);
+			FlagsAddr = hw->TxBuffInfoAddr + ((uintptr_t) (&pTxBuffInfo->Flags));
+			/* Read Modify the Flags to ask the FW to WRAP */
+			hw->pfnDevDRAMRead(hw,FlagsAddr,1,&regVal);
+			regVal |= DFW_FLAGS_WRAP;
+			hw->pfnDevDRAMWrite(hw,FlagsAddr,1,&regVal);
+
+			/* Indicate Busy to the application because we have to get new buffers from FW */
+			*empty_sz=0;
+			/* *DramAddrOut=0; */
+			*flags=0;
+			/* Wait for the next interrupt from the HW */
+			hw->TxFwInputBuffInfo.DramBuffSzInBytes = 0;
+			hw->TxFwInputBuffInfo.DramBuffAdd = 0;
+			return true;
+		}
+		else
+			hw->SingleThreadAppFIFOEmpty = true;
+	}
+	else if((*flags & 0x04) != 0x04)
+		hw->EmptyCnt++;		/*OS_INTERLOCK_INCREMENT(&pHWExt->EmptyCnt); */
+
+	/* Different from our Windows implementation */
+	/* set bit 7 of the flags field to indicate that we have to use the destination address for TX */
+	*flags |= BC_BIT(7);
+
+	return false; /*Indicate Empty*/
+}
+
+enum BC_STATUS crystalhd_flea_fw_cmd_post_proc(struct crystalhd_hw *hw, struct BC_FW_CMD *fw_cmd)
+{
+	enum BC_STATUS sts = BC_STS_SUCCESS;
+	struct dec_rsp_channel_start_video *st_rsp = NULL;
+	struct C011_TS_CMD				*pGenRsp = NULL;
+	struct dec_rsp_channel_channel_open *pRsp  = NULL;
+
+	pGenRsp = (struct C011_TS_CMD *) fw_cmd->rsp;
+
+	switch (fw_cmd->cmd[0]) {
+		case eCMD_C011_DEC_CHAN_STREAM_OPEN:
+			hw->channelNum = pGenRsp->ulParams[2];
+
+			dev_dbg(&hw->adp->pdev->dev, "Snooped Stream Open Cmd For ChNo:%x\n", hw->channelNum);
+			break;
+		case eCMD_C011_DEC_CHAN_OPEN:
+			pRsp = (struct dec_rsp_channel_channel_open *)pGenRsp;
+			hw->channelNum = pRsp->ChannelID;
+
+			/* used in Flea to update the Tx Buffer stats */
+			hw->TxBuffInfoAddr = pRsp->transportStreamCaptureAddr;
+			hw->TxFwInputBuffInfo.DramBuffAdd=0;
+			hw->TxFwInputBuffInfo.DramBuffSzInBytes=0;
+			hw->TxFwInputBuffInfo.Flags=0;
+			hw->TxFwInputBuffInfo.HostXferSzInBytes=0;
+			hw->TxFwInputBuffInfo.SeqNum=0;
+
+			/* NAREN Init power management states here when we start the channel */
+			hw->PwrDwnTxIntr = false;
+			hw->PwrDwnPiQIntr = false;
+			hw->EmptyCnt = 0;
+			hw->SingleThreadAppFIFOEmpty = false;
+
+			dev_dbg(&hw->adp->pdev->dev, "Snooped ChOpen Cmd For ChNo:%x TxBuffAddr:%x\n",
+					hw->channelNum,
+					hw->TxBuffInfoAddr);
+			break;
+		case eCMD_C011_DEC_CHAN_START_VIDEO:
+			st_rsp = (struct dec_rsp_channel_start_video *)fw_cmd->rsp;
+			hw->pib_del_Q_addr = st_rsp->picInfoDeliveryQ;
+			hw->pib_rel_Q_addr = st_rsp->picInfoReleaseQ;
+
+			dev_dbg(&hw->adp->pdev->dev, "Snooping CHAN_START_VIDEO command to get the Addr of Del/Rel Queue\n");
+			dev_dbg(&hw->adp->pdev->dev, "DelQAddr:%x RelQAddr:%x\n",
+					hw->pib_del_Q_addr, hw->pib_rel_Q_addr);
+			break;
+		default:
+			break;
+	}
+	return sts;
+}
+
+enum BC_STATUS crystalhd_flea_do_fw_cmd(struct crystalhd_hw *hw, struct BC_FW_CMD *fw_cmd)
+{
+	struct device *dev;
+	uint32_t cnt = 0, cmd_res_addr;
+	uint32_t *cmd_buff, *res_buff;
+	wait_queue_head_t fw_cmd_event;
+	int rc = 0;
+	enum BC_STATUS sts;
+	unsigned long flags;
+
+	crystalhd_create_event(&fw_cmd_event);
+
+	if (!hw || !fw_cmd) {
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
+		return BC_STS_INV_ARG;
+	}
+
+	dev = &hw->adp->pdev->dev;
+
+	dev_dbg(dev, "%s entered\n", __func__);
+
+	cmd_buff = fw_cmd->cmd;
+	res_buff = fw_cmd->rsp;
+
+	if (!cmd_buff || !res_buff) {
+		dev_err(dev, "Invalid Parameters for F/W Command\n");
+		return BC_STS_INV_ARG;
+	}
+
+	hw->fwcmd_evt_sts = 0;
+	hw->pfw_cmd_event = &fw_cmd_event;
+	hw->FwCmdCnt++;
+
+	if(hw->FleaPowerState != FLEA_PS_ACTIVE)
+	{
+		crystalhd_flea_set_next_power_state(hw,	FLEA_EVT_FW_CMD_POST);
+	}
+
+	spin_lock_irqsave(&hw->lock, flags);
+
+	/*Write the command to the memory*/
+	hw->pfnDevDRAMWrite(hw, hw->fwcmdPostAddr, FW_CMD_BUFF_SZ, cmd_buff);
+
+	/*Memory Read for memory arbitrator flush*/
+	hw->pfnDevDRAMRead(hw, hw->fwcmdPostAddr, 1, &cnt);
+
+	/* Write the command address to mailbox */
+	hw->pfnWriteDevRegister(hw->adp, hw->fwcmdPostMbox, hw->fwcmdPostAddr);
+
+	spin_unlock_irqrestore(&hw->lock, flags);
+
+	msleep_interruptible(50);
+
+	/* FW commands should complete even if we got a signal from the upper layer */
+	crystalhd_wait_on_event(&fw_cmd_event, hw->fwcmd_evt_sts,
+							20000, rc, true);
+
+	if (!rc) {
+		sts = BC_STS_SUCCESS;
+	} else if (rc == -EBUSY) {
+		dev_err(dev, "Firmware command T/O\n");
+		sts = BC_STS_TIMEOUT;
+	} else if (rc == -EINTR) {
+		dev_info(dev, "FwCmd Wait Signal - Can Never Happen\n");
+		sts = BC_STS_IO_USER_ABORT;
+	} else {
+		dev_err(dev, "FwCmd IO Error.\n");
+		sts = BC_STS_IO_ERROR;
+	}
+
+	if (sts != BC_STS_SUCCESS) {
+		dev_err(dev, "FwCmd Failed.\n");
+		return sts;
+	}
+
+	spin_lock_irqsave(&hw->lock, flags);
+
+	/*Get the Responce Address*/
+	cmd_res_addr = hw->pfnReadDevRegister(hw->adp, hw->fwcmdRespMbox);
+
+	/*Read the Response*/
+	hw->pfnDevDRAMRead(hw, cmd_res_addr, FW_CMD_BUFF_SZ, res_buff);
+
+	spin_unlock_irqrestore(&hw->lock, flags);
+
+	if (res_buff[2] != 0) {
+		dev_err(dev, "res_buff[2] != C011_RET_SUCCESS\n");
+		return BC_STS_FW_CMD_ERR;
+	}
+
+	sts = crystalhd_flea_fw_cmd_post_proc(hw, fw_cmd);
+	if (sts != BC_STS_SUCCESS)
+		dev_err(dev, "crystalhd_fw_cmd_post_proc Failed.\n");
+
+	return sts;
+
+}
+
+void crystalhd_flea_get_dnsz(struct crystalhd_hw *hw, uint32_t list_index, uint32_t *y_dw_dnsz, uint32_t *uv_dw_dnsz)
+{
+	uint32_t y_dn_sz_reg, uv_dn_sz_reg;
+
+	if (!list_index) {
+		y_dn_sz_reg  = BCHP_MISC1_Y_RX_LIST0_CUR_BYTE_CNT;
+		uv_dn_sz_reg = BCHP_MISC1_HIF_RX_LIST0_CUR_BYTE_CNT;
+	} else {
+		y_dn_sz_reg  = BCHP_MISC1_Y_RX_LIST1_CUR_BYTE_CNT;
+		uv_dn_sz_reg = BCHP_MISC1_HIF_RX_LIST1_CUR_BYTE_CNT;
+	}
+
+	*y_dw_dnsz  = hw->pfnReadFPGARegister(hw->adp, y_dn_sz_reg);
+	*uv_dw_dnsz = hw->pfnReadFPGARegister(hw->adp, uv_dn_sz_reg);
+
+	return ;
+}
+
+enum BC_STATUS crystalhd_flea_hw_pause(struct crystalhd_hw *hw, bool state)
+{
+	/*printk("%s: Set flea to power down.\n", __func__); */
+	crystalhd_flea_set_next_power_state(hw,	FLEA_EVT_FLL_CHANGE);
+	return BC_STS_SUCCESS;
+}
+
+bool crystalhd_flea_peek_next_decoded_frame(struct crystalhd_hw *hw, uint64_t *meta_payload, uint32_t *picNumFlags, uint32_t PicWidth)
+{
+	unsigned long flags = 0;
+	struct crystalhd_dioq *ioq;
+	struct crystalhd_elem *tmp;
+	struct crystalhd_rx_dma_pkt *rpkt;
+
+	*meta_payload = 0;
+
+	ioq = hw->rx_rdyq;
+	spin_lock_irqsave(&ioq->lock, flags);
+
+	if ((ioq->count > 0) && (ioq->head != (struct crystalhd_elem *)&ioq->head)) {
+		tmp = ioq->head;
+		spin_unlock_irqrestore(&ioq->lock, flags);
+		rpkt = (struct crystalhd_rx_dma_pkt *)tmp->data;
+		if (rpkt) {
+			flea_GetPictureInfo(hw, rpkt, picNumFlags, meta_payload);
+			/*printk("%s: flea_GetPictureInfo Pic#:%d\n", __func__, PicNumber); */
+		}
+		return true;
+	}
+	spin_unlock_irqrestore(&ioq->lock, flags);
+
+	return false;
+
+}
+
+void crystalhd_flea_clear_rx_errs_intrs(struct crystalhd_hw *hw)
+/*
+-- Clears all the errors and interrupt on RX DMA engine.
+*/
+{
+	uint32_t ulRegVal;
+	union FLEA_INTR_BITS_COMMON	IntrToClear,IntrSts;
+
+	IntrToClear.WholeReg = 0;
+	IntrSts.WholeReg = 0;
+
+	IntrSts.WholeReg = hw->pfnReadDevRegister(hw->adp, BCHP_INTR_INTR_STATUS);
+	if(IntrSts.WholeReg)
+	{
+		ulRegVal = hw->pfnReadDevRegister(hw->adp, BCHP_MISC1_Y_RX_ERROR_STATUS);
+		hw->pfnWriteDevRegister(hw->adp, BCHP_MISC1_Y_RX_ERROR_STATUS, ulRegVal);
+		ulRegVal = hw->pfnReadDevRegister(hw->adp, BCHP_MISC1_HIF_RX_ERROR_STATUS);
+		hw->pfnWriteDevRegister(hw->adp, BCHP_MISC1_HIF_RX_ERROR_STATUS, ulRegVal);
+
+		IntrToClear.L0UVRxDMADone	=	IntrSts.L0UVRxDMADone;
+		IntrToClear.L0UVRxDMAErr	=	IntrSts.L0UVRxDMAErr;
+		IntrToClear.L0YRxDMADone	=	IntrSts.L0YRxDMADone;
+		IntrToClear.L0YRxDMAErr		=	IntrSts.L0YRxDMAErr;
+		IntrToClear.L1UVRxDMADone	=	IntrSts.L1UVRxDMADone;
+		IntrToClear.L1UVRxDMAErr	=	IntrSts.L1UVRxDMAErr;
+		IntrToClear.L1YRxDMADone	=	IntrSts.L1YRxDMADone;
+		IntrToClear.L1YRxDMAErr		=	IntrSts.L1YRxDMAErr;
+
+		hw->pfnWriteDevRegister(hw->adp, BCHP_INTR_INTR_CLR_REG, IntrToClear.WholeReg);
+
+		hw->pfnWriteDevRegister(hw->adp, BCHP_INTR_EOI_CTRL, 1);
+	}
+	return;
+}
+
+
+void crystalhd_flea_stop_rx_dma_engine(struct crystalhd_hw *hw)
+{
+	union FLEA_INTR_BITS_COMMON	IntrStsValue;
+	bool failedL0 = true, failedL1 = true;
+	uint32_t pollCnt = 0;
+
+	hw->RxCaptureState = 2;
+
+	if((hw->rx_list_sts[0] == sts_free) && (hw->rx_list_sts[1] == sts_free)) {
+		hw->RxCaptureState = 0;
+		hw->RxSeqNum = 0;
+		return; /* Nothing to be done */
+	}
+
+	if(hw->rx_list_sts[0] == sts_free)
+		failedL0 = false;
+	if(hw->rx_list_sts[1] == sts_free)
+		failedL1 = false;
+
+	while(1)
+	{
+		IntrStsValue.WholeReg = hw->pfnReadDevRegister(hw->adp, BCHP_INTR_INTR_STATUS);
+
+		if(hw->rx_list_sts[0] != sts_free) {
+			if( (IntrStsValue.L0YRxDMADone)  || (IntrStsValue.L0YRxDMAErr) ||
+				(IntrStsValue.L0UVRxDMADone) || (IntrStsValue.L0UVRxDMAErr) )
+			{
+				failedL0 = false;
+			}
+		}
+		else
+			failedL0 = false;
+
+		if(hw->rx_list_sts[1] != sts_free) {
+			if( (IntrStsValue.L1YRxDMADone)  || (IntrStsValue.L1YRxDMAErr) ||
+				(IntrStsValue.L1UVRxDMADone) || (IntrStsValue.L1UVRxDMAErr) )
+			{
+				failedL1 = false;
+			}
+		}
+		else
+			failedL1 = false;
+
+		msleep_interruptible(10);
+
+		if(pollCnt >= MAX_VALID_POLL_CNT)
+			break;
+
+		if((failedL0 == false) && (failedL1 == false))
+			break;
+
+		pollCnt++;
+	}
+
+	if(failedL0 || failedL1)
+		printk("Failed to stop RX DMA\n");
+
+	hw->RxCaptureState = 0;
+	hw->RxSeqNum = 0;
+
+	crystalhd_flea_clear_rx_errs_intrs(hw);
+}
+
+enum BC_STATUS crystalhd_flea_hw_fire_rxdma(struct crystalhd_hw *hw,
+									   struct crystalhd_rx_dma_pkt *rx_pkt)
+{
+	struct device *dev;
+	addr_64 desc_addr;
+	unsigned long flags;
+	PIC_DELIVERY_HOST_INFO	PicDeliInfo;
+	uint32_t BuffSzInDwords;
+
+	if (!hw || !rx_pkt) {
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
+		return BC_STS_INV_ARG;
+	}
+
+	dev = &hw->adp->pdev->dev;
+
+	if (hw->rx_list_post_index >= DMA_ENGINE_CNT) {
+		dev_err(dev, "List Out Of bounds %x\n", hw->rx_list_post_index);
+		return BC_STS_INV_ARG;
+	}
+
+	if(hw->RxCaptureState != 1) {
+		dev_err(dev, "Capture not enabled\n");
+		return BC_STS_BUSY;
+	}
+
+	spin_lock_irqsave(&hw->rx_lock, flags);
+	if (hw->rx_list_sts[hw->rx_list_post_index]) {
+		dev_dbg(dev, "HW list is busy\n");
+		spin_unlock_irqrestore(&hw->rx_lock, flags);
+		return BC_STS_BUSY;
+	}
+
+	if (!TEST_BIT(hw->PicQSts, hw->channelNum)) {
+		/* NO pictures available for this channel */
+		dev_dbg(dev, "No Picture Available for DMA\n");
+		spin_unlock_irqrestore(&hw->rx_lock, flags);
+		return BC_STS_BUSY;
+	}
+
+	CLEAR_BIT(hw->PicQSts, hw->channelNum);
+
+	desc_addr.full_addr = rx_pkt->desc_mem.phy_addr;
+
+	PicDeliInfo.ListIndex = hw->rx_list_post_index;
+	PicDeliInfo.RxSeqNumber = hw->RxSeqNum;
+	PicDeliInfo.HostDescMemLowAddr_Y = desc_addr.low_part;
+	PicDeliInfo.HostDescMemHighAddr_Y = desc_addr.high_part;
+
+	if (rx_pkt->uv_phy_addr) {
+		/* Program the UV descriptor */
+		desc_addr.full_addr = rx_pkt->uv_phy_addr;
+		PicDeliInfo.HostDescMemLowAddr_UV = desc_addr.low_part;
+		PicDeliInfo.HostDescMemHighAddr_UV = desc_addr.high_part;
+	}
+
+	rx_pkt->pkt_tag = hw->rx_pkt_tag_seed + hw->rx_list_post_index;
+	hw->rx_list_sts[hw->rx_list_post_index] |= rx_waiting_y_intr;
+	if (rx_pkt->uv_phy_addr)
+		hw->rx_list_sts[hw->rx_list_post_index] |= rx_waiting_uv_intr;
+	hw->rx_list_post_index = (hw->rx_list_post_index + 1) % DMA_ENGINE_CNT;
+
+	spin_unlock_irqrestore(&hw->rx_lock, flags);
+
+	crystalhd_dioq_add(hw->rx_actq, (void *)rx_pkt, false, rx_pkt->pkt_tag);
+
+	BuffSzInDwords = (sizeof (PicDeliInfo) - sizeof(PicDeliInfo.Reserved))/4;
+
+	/*
+	-- Write the parameters in DRAM.
+	*/
+	spin_lock_irqsave(&hw->lock, flags);
+	hw->pfnDevDRAMWrite(hw, hw->FleaRxPicDelAddr, BuffSzInDwords, (uint32_t*)&PicDeliInfo);
+	hw->pfnWriteDevRegister(hw->adp, RX_POST_MAILBOX, hw->channelNum);
+	spin_unlock_irqrestore(&hw->lock, flags);
+
+	hw->RxSeqNum++;
+
+	return BC_STS_SUCCESS;
+}
+
+enum BC_STATUS crystalhd_flea_hw_post_cap_buff(struct crystalhd_hw *hw, struct crystalhd_rx_dma_pkt *rx_pkt)
+{
+	enum BC_STATUS sts = crystalhd_flea_hw_fire_rxdma(hw, rx_pkt);
+
+	if (sts != BC_STS_SUCCESS)
+		crystalhd_dioq_add(hw->rx_freeq, (void *)rx_pkt, false, rx_pkt->pkt_tag);
+
+	hw->pfnNotifyFLLChange(hw, false);
+
+	return sts;
+}
+
+void crystalhd_flea_start_tx_dma_engine(struct crystalhd_hw *hw, uint8_t list_id, addr_64 desc_addr)
+{
+	uint32_t dma_cntrl;
+	uint32_t first_desc_u_addr, first_desc_l_addr;
+	struct TX_INPUT_BUFFER_INFO	TxBuffInfo;
+	uint32_t WrAddr=0, WrSzInDWords=0;
+
+	hw->EmptyCnt--;
+	hw->SingleThreadAppFIFOEmpty = false;
+
+	/* For FLEA, first update the HW with the DMA parameters */
+	WrSzInDWords = (sizeof(TxBuffInfo.DramBuffAdd) +
+					sizeof(TxBuffInfo.DramBuffSzInBytes) +
+					sizeof(TxBuffInfo.HostXferSzInBytes))/4;
+
+	/*Make the DramBuffSz as Zero skip first ULONG*/
+	WrAddr = hw->TxBuffInfoAddr;
+	hw->TxFwInputBuffInfo.DramBuffAdd = TxBuffInfo.DramBuffAdd = 0;
+	hw->TxFwInputBuffInfo.DramBuffSzInBytes =  TxBuffInfo.DramBuffSzInBytes = 0;
+	TxBuffInfo.HostXferSzInBytes = hw->TxFwInputBuffInfo.HostXferSzInBytes;
+
+	hw->pfnDevDRAMWrite(hw,	WrAddr,	WrSzInDWords, (uint32_t *)&TxBuffInfo);
+
+	if (list_id == 0) {
+		first_desc_u_addr = BCHP_MISC1_TX_FIRST_DESC_U_ADDR_LIST0;
+		first_desc_l_addr = BCHP_MISC1_TX_FIRST_DESC_L_ADDR_LIST0;
+	} else {
+		first_desc_u_addr = BCHP_MISC1_TX_FIRST_DESC_U_ADDR_LIST1;
+		first_desc_l_addr = BCHP_MISC1_TX_FIRST_DESC_L_ADDR_LIST1;
+	}
+
+	dma_cntrl = hw->pfnReadFPGARegister(hw->adp, BCHP_MISC1_TX_SW_DESC_LIST_CTRL_STS);
+	if (!(dma_cntrl & BCHP_MISC1_TX_SW_DESC_LIST_CTRL_STS_TX_DMA_RUN_STOP_MASK)) {
+		dma_cntrl |= BCHP_MISC1_TX_SW_DESC_LIST_CTRL_STS_TX_DMA_RUN_STOP_MASK;
+		hw->pfnWriteFPGARegister(hw->adp, BCHP_MISC1_TX_SW_DESC_LIST_CTRL_STS,
+								 dma_cntrl);
+	}
+
+	hw->pfnWriteFPGARegister(hw->adp, first_desc_u_addr, desc_addr.high_part);
+
+	hw->pfnWriteFPGARegister(hw->adp, first_desc_l_addr, desc_addr.low_part | 0x01);
+	/* Be sure we set the valid bit ^^^^ */
+
+	return;
+}
+
+enum BC_STATUS crystalhd_flea_stop_tx_dma_engine(struct crystalhd_hw *hw)
+{
+	struct device *dev;
+	uint32_t dma_cntrl, cnt = 30;
+	uint32_t l1 = 1, l2 = 1;
+
+	dma_cntrl = hw->pfnReadFPGARegister(hw->adp, BCHP_MISC1_TX_SW_DESC_LIST_CTRL_STS);
+
+	dev = &hw->adp->pdev->dev;
+
+	dev_dbg(dev, "Stopping TX DMA Engine..\n");
+
+	if (!(dma_cntrl & BCHP_MISC1_TX_SW_DESC_LIST_CTRL_STS_TX_DMA_RUN_STOP_MASK)) {
+		hw->TxList0Sts = ListStsFree;
+		hw->TxList1Sts = ListStsFree;
+		hw->tx_list_post_index = 0;
+
+		dev_dbg(dev, "Already Stopped\n");
+		return BC_STS_SUCCESS;
+	}
+
+	crystalhd_flea_disable_interrupts(hw);
+
+	/* Issue stop to HW */
+	dma_cntrl &= ~BCHP_MISC1_TX_SW_DESC_LIST_CTRL_STS_TX_DMA_RUN_STOP_MASK;
+	hw->pfnWriteFPGARegister(hw->adp, BCHP_MISC1_TX_SW_DESC_LIST_CTRL_STS, dma_cntrl);
+
+	dev_dbg(dev, "Cleared the DMA Start bit\n");
+
+	/* Poll for 3seconds (30 * 100ms) on both the lists..*/
+	while ((l1 || l2) && cnt) {
+
+		if (l1) {
+			l1 = hw->pfnReadFPGARegister(hw->adp,
+										 BCHP_MISC1_TX_FIRST_DESC_L_ADDR_LIST0);
+			l1 &= BCHP_MISC1_TX_SW_DESC_LIST_CTRL_STS_TX_DMA_RUN_STOP_MASK;
+		}
+
+		if (l2) {
+			l2 = hw->pfnReadFPGARegister(hw->adp,
+										 BCHP_MISC1_TX_FIRST_DESC_L_ADDR_LIST1);
+			l2 &= BCHP_MISC1_TX_SW_DESC_LIST_CTRL_STS_TX_DMA_RUN_STOP_MASK;
+		}
+
+		msleep_interruptible(100);
+
+		cnt--;
+	}
+
+	if (!cnt) {
+		dev_err(dev, "Failed to stop TX DMA.. l1 %d, l2 %d\n", l1, l2);
+		crystalhd_flea_enable_interrupts(hw);
+		return BC_STS_ERROR;
+	}
+
+	hw->TxList0Sts = ListStsFree;
+	hw->TxList1Sts = ListStsFree;
+
+	hw->tx_list_post_index = 0;
+	dev_dbg(dev, "stopped TX DMA..\n");
+	crystalhd_flea_enable_interrupts(hw);
+
+	return BC_STS_SUCCESS;
+}
+
+static void crystalhd_flea_update_tx_done_to_fw(struct crystalhd_hw *hw)
+{
+	struct device *dev;
+	uint32_t				regVal		= 0;
+	uint32_t				seqNumAddr	= 0;
+	uint32_t				seqVal		= 0;
+	struct TX_INPUT_BUFFER_INFO	*pTxBuffInfo;
+
+	dev = &hw->adp->pdev->dev;
+	/*
+	-- first update the sequence number and then update the
+	-- scratch.
+	*/
+	pTxBuffInfo = (struct TX_INPUT_BUFFER_INFO *) (0);
+	seqNumAddr = hw->TxBuffInfoAddr + ((uintptr_t) (&pTxBuffInfo->SeqNum));
+
+	/*Read the seqnece number */
+	hw->pfnDevDRAMRead(hw, seqNumAddr, 1, &regVal);
+
+	seqVal = regVal;
+	regVal++;
+
+	/*Increment and Write back to same memory location. */
+	hw->pfnDevDRAMWrite(hw,	seqNumAddr, 1, &regVal);
+
+	regVal = hw->pfnReadDevRegister(hw->adp, INDICATE_TX_DONE_REG);
+	regVal++;
+	hw->pfnWriteDevRegister(hw->adp, INDICATE_TX_DONE_REG, regVal);
+
+	dev_dbg(dev, "TxUpdate[SeqNum DRAM Addr:%x] SeqNum:%x ScratchValue:%x\n",
+		seqNumAddr, seqVal, regVal);
+
+	return;
+}
+
+bool crystalhd_flea_tx_list0_handler(struct crystalhd_hw *hw, uint32_t err_sts)
+{
+	uint32_t err_mask, tmp;
+
+	err_mask = MISC1_TX_DMA_ERROR_STATUS_TX_L0_DESC_TX_ABORT_ERRORS_MASK |
+	MISC1_TX_DMA_ERROR_STATUS_TX_L0_DMA_DATA_TX_ABORT_ERRORS_MASK |
+	MISC1_TX_DMA_ERROR_STATUS_TX_L0_FIFO_FULL_ERRORS_MASK;
+
+	if (!(err_sts & err_mask))
+		return false;
+
+	dev_err(&hw->adp->pdev->dev, "Error on Tx-L0 %x\n", err_sts);
+
+	tmp = err_mask;
+
+	if (err_sts & MISC1_TX_DMA_ERROR_STATUS_TX_L0_FIFO_FULL_ERRORS_MASK)
+		tmp &= ~MISC1_TX_DMA_ERROR_STATUS_TX_L0_FIFO_FULL_ERRORS_MASK;
+
+	if (tmp) {
+		/* reset list index.*/
+		hw->tx_list_post_index = 0;
+	}
+
+	tmp = err_sts & err_mask;
+	hw->pfnWriteDevRegister(hw->adp, BCHP_MISC1_TX_DMA_ERROR_STATUS, tmp);
+
+	return true;
+}
+
+bool crystalhd_flea_tx_list1_handler(struct crystalhd_hw *hw, uint32_t err_sts)
+{
+	uint32_t err_mask, tmp;
+
+	err_mask = MISC1_TX_DMA_ERROR_STATUS_TX_L1_DESC_TX_ABORT_ERRORS_MASK |
+	MISC1_TX_DMA_ERROR_STATUS_TX_L1_DMA_DATA_TX_ABORT_ERRORS_MASK |
+	MISC1_TX_DMA_ERROR_STATUS_TX_L1_FIFO_FULL_ERRORS_MASK;
+
+	if (!(err_sts & err_mask))
+		return false;
+
+	dev_err(&hw->adp->pdev->dev, "Error on Tx-L1 %x\n", err_sts);
+
+	tmp = err_mask;
+
+	if (err_sts & MISC1_TX_DMA_ERROR_STATUS_TX_L1_FIFO_FULL_ERRORS_MASK)
+		tmp &= ~MISC1_TX_DMA_ERROR_STATUS_TX_L1_FIFO_FULL_ERRORS_MASK;
+
+	if (tmp) {
+		/* reset list index.*/
+		hw->tx_list_post_index = 0;
+	}
+
+	tmp = err_sts & err_mask;
+	hw->pfnWriteDevRegister(hw->adp, BCHP_MISC1_TX_DMA_ERROR_STATUS, tmp);
+
+	return true;
+}
+
+void crystalhd_flea_tx_isr(struct crystalhd_hw *hw, union FLEA_INTR_BITS_COMMON int_sts)
+{
+	uint32_t err_sts;
+
+	if (int_sts.L0TxDMADone) {
+		hw->TxList0Sts &= ~TxListWaitingForIntr;
+		crystalhd_hw_tx_req_complete(hw, hw->tx_ioq_tag_seed + 0, BC_STS_SUCCESS);
+	}
+
+	if (int_sts.L1TxDMADone) {
+		hw->TxList1Sts &= ~TxListWaitingForIntr;
+		crystalhd_hw_tx_req_complete(hw, hw->tx_ioq_tag_seed + 1, BC_STS_SUCCESS);
+	}
+
+	if (!(int_sts.L0TxDMAErr || int_sts.L1TxDMAErr))
+		/* No error mask set.. */
+		return;
+
+	/* Handle Tx errors. */
+	err_sts = hw->pfnReadDevRegister(hw->adp, BCHP_MISC1_TX_DMA_ERROR_STATUS);
+
+	if (crystalhd_flea_tx_list0_handler(hw, err_sts))
+		crystalhd_hw_tx_req_complete(hw, hw->tx_ioq_tag_seed + 0, BC_STS_ERROR);
+
+	if (crystalhd_flea_tx_list1_handler(hw, err_sts))
+		crystalhd_hw_tx_req_complete(hw, hw->tx_ioq_tag_seed + 1, BC_STS_ERROR);
+
+	hw->stats.tx_errors++;
+}
+
+bool crystalhd_flea_rx_list0_handler(struct crystalhd_hw *hw,
+									 union FLEA_INTR_BITS_COMMON int_sts,
+									 uint32_t y_err_sts,
+									 uint32_t uv_err_sts)
+{
+	uint32_t tmp;
+	enum list_sts tmp_lsts;
+
+	if (!(y_err_sts & GET_Y0_ERR_MSK) && !(uv_err_sts & GET_UV0_ERR_MSK))
+		return false;
+
+	tmp_lsts = hw->rx_list_sts[0];
+
+	/* Y0 - DMA */
+	tmp = y_err_sts & GET_Y0_ERR_MSK;
+	if (int_sts.L0YRxDMADone)
+		hw->rx_list_sts[0] &= ~rx_waiting_y_intr;
+
+	if (y_err_sts & MISC1_Y_RX_ERROR_STATUS_RX_L0_UNDERRUN_ERROR_MASK) {
+		hw->rx_list_sts[0] &= ~rx_waiting_y_intr;
+		tmp &= ~MISC1_Y_RX_ERROR_STATUS_RX_L0_UNDERRUN_ERROR_MASK;
+	}
+
+	if (y_err_sts & MISC1_Y_RX_ERROR_STATUS_RX_L0_FIFO_FULL_ERRORS_MASK) {
+		/* Can never happen for Flea */
+		printk("FLEA fifo full - impossible\n");
+		hw->rx_list_sts[0] &= ~rx_y_mask;
+		hw->rx_list_sts[0] |= rx_y_error;
+		tmp &= ~MISC1_Y_RX_ERROR_STATUS_RX_L0_FIFO_FULL_ERRORS_MASK;
+	}
+
+	if (tmp) {
+		hw->rx_list_sts[0] &= ~rx_y_mask;
+		hw->rx_list_sts[0] |= rx_y_error;
+		hw->rx_list_post_index = 0;
+	}
+
+	/* UV0 - DMA */
+	tmp = uv_err_sts & GET_UV0_ERR_MSK;
+	if (int_sts.L0UVRxDMADone)
+		hw->rx_list_sts[0] &= ~rx_waiting_uv_intr;
+
+	if (uv_err_sts & MISC1_UV_RX_ERROR_STATUS_RX_L0_UNDERRUN_ERROR_MASK) {
+		hw->rx_list_sts[0] &= ~rx_waiting_uv_intr;
+		tmp &= ~MISC1_UV_RX_ERROR_STATUS_RX_L0_UNDERRUN_ERROR_MASK;
+	}
+
+	if (uv_err_sts & MISC1_UV_RX_ERROR_STATUS_RX_L0_FIFO_FULL_ERRORS_MASK) {
+		/* Can never happen for Flea */
+		printk("FLEA fifo full - impossible\n");
+		hw->rx_list_sts[0] &= ~rx_uv_mask;
+		hw->rx_list_sts[0] |= rx_uv_error;
+		tmp &= ~MISC1_UV_RX_ERROR_STATUS_RX_L0_FIFO_FULL_ERRORS_MASK;
+	}
+
+	if (tmp) {
+		hw->rx_list_sts[0] &= ~rx_uv_mask;
+		hw->rx_list_sts[0] |= rx_uv_error;
+		hw->rx_list_post_index = 0;
+	}
+
+	if (y_err_sts & GET_Y0_ERR_MSK) {
+		tmp = y_err_sts & GET_Y0_ERR_MSK;
+		hw->pfnWriteDevRegister(hw->adp, BCHP_MISC1_Y_RX_ERROR_STATUS, tmp);
+	}
+
+	if (uv_err_sts & GET_UV0_ERR_MSK) {
+		tmp = uv_err_sts & GET_UV0_ERR_MSK;
+		hw->pfnWriteDevRegister(hw->adp, BCHP_MISC1_HIF_RX_ERROR_STATUS, tmp);
+	}
+
+	return (tmp_lsts != hw->rx_list_sts[0]);
+}
+
+bool crystalhd_flea_rx_list1_handler(struct crystalhd_hw *hw,
+									 union FLEA_INTR_BITS_COMMON int_sts,
+									 uint32_t y_err_sts,
+									 uint32_t uv_err_sts)
+{
+	uint32_t tmp;
+	enum list_sts tmp_lsts;
+
+	if (!(y_err_sts & GET_Y1_ERR_MSK) && !(uv_err_sts & GET_UV1_ERR_MSK))
+		return false;
+
+	tmp_lsts = hw->rx_list_sts[1];
+
+	/* Y1 - DMA */
+	tmp = y_err_sts & GET_Y1_ERR_MSK;
+	if (int_sts.L1YRxDMADone)
+		hw->rx_list_sts[1] &= ~rx_waiting_y_intr;
+
+	if (y_err_sts & MISC1_Y_RX_ERROR_STATUS_RX_L1_UNDERRUN_ERROR_MASK) {
+		hw->rx_list_sts[1] &= ~rx_waiting_y_intr;
+		tmp &= ~MISC1_Y_RX_ERROR_STATUS_RX_L1_UNDERRUN_ERROR_MASK;
+	}
+
+	if (y_err_sts & MISC1_Y_RX_ERROR_STATUS_RX_L1_FIFO_FULL_ERRORS_MASK) {
+		/* Can never happen for Flea */
+		printk("FLEA fifo full - impossible\n");
+		hw->rx_list_sts[1] &= ~rx_y_mask;
+		hw->rx_list_sts[1] |= rx_y_error;
+		tmp &= ~MISC1_Y_RX_ERROR_STATUS_RX_L1_FIFO_FULL_ERRORS_MASK;
+	}
+
+	if (tmp) {
+		hw->rx_list_sts[1] &= ~rx_y_mask;
+		hw->rx_list_sts[1] |= rx_y_error;
+		hw->rx_list_post_index = 0;
+	}
+
+	/* UV1 - DMA */
+	tmp = uv_err_sts & GET_UV1_ERR_MSK;
+	if (int_sts.L1UVRxDMADone)
+		hw->rx_list_sts[1] &= ~rx_waiting_uv_intr;
+
+	if (uv_err_sts & MISC1_UV_RX_ERROR_STATUS_RX_L1_UNDERRUN_ERROR_MASK) {
+		hw->rx_list_sts[1] &= ~rx_waiting_uv_intr;
+		tmp &= ~MISC1_UV_RX_ERROR_STATUS_RX_L1_UNDERRUN_ERROR_MASK;
+	}
+
+	if (uv_err_sts & MISC1_UV_RX_ERROR_STATUS_RX_L1_FIFO_FULL_ERRORS_MASK) {
+		/* Can never happen for Flea */
+		printk("FLEA fifo full - impossible\n");
+		hw->rx_list_sts[1] &= ~rx_uv_mask;
+		hw->rx_list_sts[1] |= rx_uv_error;
+		tmp &= ~MISC1_UV_RX_ERROR_STATUS_RX_L1_FIFO_FULL_ERRORS_MASK;
+	}
+
+	if (tmp) {
+		hw->rx_list_sts[1] &= ~rx_uv_mask;
+		hw->rx_list_sts[1] |= rx_uv_error;
+		hw->rx_list_post_index = 0;
+	}
+
+	if (y_err_sts & GET_Y1_ERR_MSK) {
+		tmp = y_err_sts & GET_Y1_ERR_MSK;
+		hw->pfnWriteDevRegister(hw->adp, BCHP_MISC1_Y_RX_ERROR_STATUS, tmp);
+	}
+
+	if (uv_err_sts & GET_UV1_ERR_MSK) {
+		tmp = uv_err_sts & GET_UV1_ERR_MSK;
+		hw->pfnWriteDevRegister(hw->adp, BCHP_MISC1_HIF_RX_ERROR_STATUS, tmp);
+	}
+
+	return (tmp_lsts != hw->rx_list_sts[1]);
+}
+
+void crystalhd_flea_rx_isr(struct crystalhd_hw *hw, union FLEA_INTR_BITS_COMMON intr_sts)
+{
+	unsigned long flags;
+	uint32_t i, list_avail = 0;
+	enum BC_STATUS comp_sts = BC_STS_NO_DATA;
+	uint32_t y_err_sts, uv_err_sts, y_dn_sz = 0, uv_dn_sz = 0;
+	bool ret = 0;
+
+	if (!hw) {
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
+		return;
+	}
+
+	if (!(intr_sts.L0YRxDMADone || intr_sts.L1YRxDMADone || intr_sts.L0UVRxDMADone || intr_sts.L1UVRxDMADone ||
+		intr_sts.L0YRxDMAErr || intr_sts.L1YRxDMAErr || intr_sts.L0UVRxDMAErr || intr_sts.L1UVRxDMAErr))
+		return;
+
+	spin_lock_irqsave(&hw->rx_lock, flags);
+
+	y_err_sts = hw->pfnReadDevRegister(hw->adp, BCHP_MISC1_Y_RX_ERROR_STATUS);
+	uv_err_sts = hw->pfnReadDevRegister(hw->adp, BCHP_MISC1_HIF_RX_ERROR_STATUS);
+
+	for (i = 0; i < DMA_ENGINE_CNT; i++) {
+		/* Update States..*/
+		if (i == 0)
+			ret = crystalhd_flea_rx_list0_handler(hw, intr_sts, y_err_sts, uv_err_sts);
+		else
+			ret = crystalhd_flea_rx_list1_handler(hw, intr_sts, y_err_sts, uv_err_sts);
+		if (ret) {
+			switch (hw->rx_list_sts[i]) {
+				case sts_free:
+					comp_sts = BC_STS_SUCCESS;
+					list_avail = 1;
+					hw->stats.rx_success++;
+					break;
+				case rx_y_error:
+				case rx_uv_error:
+				case rx_sts_error:
+					/* We got error on both or Y or uv. */
+					hw->stats.rx_errors++;
+					hw->pfnHWGetDoneSize(hw, i, &y_dn_sz, &uv_dn_sz);
+					dev_info(&hw->adp->pdev->dev, "list_index:%x "
+					"rx[%d] rxtot[%d] Y:%x UV:%x Int:%x YDnSz:%x "
+					"UVDnSz:%x\n", i, hw->stats.rx_errors,
+							 hw->stats.rx_errors + hw->stats.rx_success,
+							 y_err_sts, uv_err_sts, intr_sts.WholeReg,
+							 y_dn_sz, uv_dn_sz);
+							 hw->rx_list_sts[i] = sts_free;
+							 comp_sts = BC_STS_ERROR;
+							 break;
+				default:
+					/* Wait for completion..*/
+					comp_sts = BC_STS_NO_DATA;
+					break;
+			}
+		}
+		/* handle completion...*/
+		if (comp_sts != BC_STS_NO_DATA) {
+			crystalhd_rx_pkt_done(hw, i, comp_sts);
+			comp_sts = BC_STS_NO_DATA;
+		}
+	}
+
+	spin_unlock_irqrestore(&hw->rx_lock, flags);
+
+	if (list_avail)
+		crystalhd_hw_start_capture(hw);
+}
+
+bool crystalhd_flea_hw_interrupt_handle(struct crystalhd_adp *adp, struct crystalhd_hw *hw)
+{
+	union FLEA_INTR_BITS_COMMON	IntrStsValue;
+	bool				bIntFound		= false;
+	bool				bPostRxBuff		= false;
+	bool				bSomeCmdDone	= false;
+	struct crystalhd_rx_dma_pkt *rx_pkt;
+
+	bool	rc = false;
+
+	if (!adp || !hw->dev_started)
+		return rc;
+
+	IntrStsValue.WholeReg=0;
+
+	IntrStsValue.WholeReg = hw->pfnReadDevRegister(hw->adp, BCHP_INTR_INTR_STATUS);
+
+	if(!IntrStsValue.WholeReg)
+		return rc;	/*Not Our interrupt*/
+
+	/*If any of the bit is set we have a problem*/
+	if(IntrStsValue.HaltIntr || IntrStsValue.PcieTgtCaAttn || IntrStsValue.PcieTgtUrAttn)
+	{
+		printk("Bad HW Error in CrystalHD Driver\n");
+		return rc;
+	}
+
+	/* Our interrupt */
+	hw->stats.num_interrupts++;
+	rc = true;
+
+	/* NAREN When In Power Down state, only interrupts possible are TXFIFO and PiQ       */
+	/* Save the state of these interrupts to process them when we resume from power down */
+	if(hw->FleaPowerState == FLEA_PS_LP_COMPLETE)
+	{
+		if(IntrStsValue.ArmMbox1Int)
+		{
+			hw->PwrDwnPiQIntr = true;
+			bIntFound = true;
+		}
+
+		if(IntrStsValue.ArmMbox2Int)
+		{
+			hw->PwrDwnTxIntr = true;
+			bIntFound = true;
+		}
+
+		/*Write End Of Interrupt for PCIE*/
+		if(bIntFound)
+		{
+			hw->pfnWriteDevRegister(hw->adp, BCHP_INTR_INTR_CLR_REG, IntrStsValue.WholeReg);
+			hw->pfnWriteDevRegister(hw->adp, BCHP_INTR_EOI_CTRL, 1);
+		}
+		return (bIntFound);
+	}
+
+	/*
+	-- Arm Mail box Zero interrupt is
+	-- BCHP_ARMCR4_BRIDGE_REG_MBOX_ARM1
+	*/
+	if(IntrStsValue.ArmMbox0Int)
+	{
+		/*HWFWCmdComplete(pHWExt,IntrBmp); */
+		/*Set the Event and the status flag*/
+		if (hw->pfw_cmd_event) {
+			hw->fwcmd_evt_sts = 1;
+			crystalhd_set_event(hw->pfw_cmd_event);
+		}
+		bIntFound = true;
+		bSomeCmdDone = true;
+		hw->FwCmdCnt--;
+	}
+
+	/* Rx interrupts */
+	crystalhd_flea_rx_isr(hw, IntrStsValue);
+
+	if( IntrStsValue.L0YRxDMADone || IntrStsValue.L1YRxDMADone || IntrStsValue.L0UVRxDMADone || IntrStsValue.L1UVRxDMADone || IntrStsValue.L0YRxDMAErr || IntrStsValue.L1YRxDMAErr )
+	{
+		bSomeCmdDone = true;
+	}
+
+
+	/* Tx interrupts*/
+	crystalhd_flea_tx_isr(hw, IntrStsValue);
+
+	/*
+	-- Indicate the TX Done to Flea Firmware.
+	*/
+	if(IntrStsValue.L0TxDMADone || IntrStsValue.L1TxDMADone || IntrStsValue.L0TxDMAErr || IntrStsValue.L1TxDMAErr)
+	{
+		crystalhd_flea_update_tx_done_to_fw(hw);
+		bSomeCmdDone = true;
+	}
+	/*
+	-- We are doing this here because we processed the interrupts.
+	-- We might want to change the PicQSts bitmap in any of the interrupts.
+	-- This should be done before trying to post the next RX buffer.
+	-- NOTE: ArmMbox1Int is BCHP_ARMCR4_BRIDGE_REG_MBOX_ARM2
+	*/
+	if(IntrStsValue.ArmMbox1Int)
+	{
+		/*pHWExt->FleaBmpIntrCnt++; */
+		crystalhd_flea_update_temperature(hw);
+		crystalhd_flea_handle_PicQSts_intr(hw);
+		bPostRxBuff = true;
+		bIntFound = true;
+	}
+
+	if(IntrStsValue.ArmMbox2Int)
+	{
+		crystalhd_flea_update_temperature(hw);
+		crystalhd_flea_update_tx_buff_info(hw);
+		bIntFound = true;
+	}
+
+	/*Write End Of Interrupt for PCIE*/
+	if(rc)
+	{
+		hw->pfnWriteDevRegister(hw->adp, BCHP_INTR_INTR_CLR_REG, IntrStsValue.WholeReg);
+		hw->pfnWriteDevRegister(hw->adp, BCHP_INTR_EOI_CTRL, 1);
+	}
+
+	/* Try to post RX Capture buffer from ISR context */
+	if(bPostRxBuff) {
+		rx_pkt = crystalhd_dioq_fetch(hw->rx_freeq);
+		if (rx_pkt)
+			hw->pfnPostRxSideBuff(hw, rx_pkt);
+	}
+
+	if( (hw->FleaPowerState == FLEA_PS_LP_PENDING) && (bSomeCmdDone))
+	{
+		/*printk("interrupt_handle: current PS:%d, bSomeCmdDone%d\n", hw->FleaPowerState,bSomeCmdDone); */
+		crystalhd_flea_set_next_power_state(hw, FLEA_EVT_CMD_COMP);
+	}
+
+	/* NAREN place the device in low power mode if we have not started playing video */
+	/*if((hw->FleaPowerState == FLEA_PS_ACTIVE) && (hw->WakeUpDecodeDone != true)) */
+	/*{ */
+	/*	if((hw->ReadyListLen == 0) && (hw->FreeListLen == 0)) */
+	/*	{ */
+	/*		crystalhd_flea_set_next_power_state(hw, FLEA_EVT_FLL_CHANGE); */
+	/*		printk("ISR Idle\n"); */
+	/*	} */
+	/*} */
+
+	return rc;
+}
+
+/* This function cannot be called from ISR context since it uses APIs that can sleep */
+bool flea_GetPictureInfo(struct crystalhd_hw *hw, struct crystalhd_rx_dma_pkt * rx_pkt,
+							uint32_t *PicNumber, uint64_t *PicMetaData)
+{
+	struct device *dev = &hw->adp->pdev->dev;
+	uint32_t PicInfoLineNum = 0, offset = 0, size = 0;
+	struct BC_PIC_INFO_BLOCK *pPicInfoLine = NULL;
+	uint32_t tmpYBuffData;
+	unsigned long res = 0;
+	uint32_t widthField = 0;
+	bool rtVal = true;
+
+	void *tmpPicInfo = NULL;
+	struct crystalhd_dio_req *dio = rx_pkt->dio_req;
+	*PicNumber = 0;
+	*PicMetaData = 0;
+
+	if (!dio)
+		goto getpictureinfo_err_nosem;
+
+/*	if(down_interruptible(&hw->fetch_sem)) */
+/*		goto getpictureinfo_err_nosem; */
+
+	tmpPicInfo = kmalloc(2 * sizeof(struct BC_PIC_INFO_BLOCK) + 16, GFP_KERNEL); /* since copy_from_user can sleep anyway */
+	if(tmpPicInfo == NULL)
+		goto getpictureinfo_err;
+	dio->pib_va = kmalloc(32, GFP_KERNEL); /* temp buffer of 32 bytes for the rest; */
+	if(dio->pib_va == NULL)
+		goto getpictureinfo_err;
+
+	offset = (rx_pkt->dio_req->uinfo.y_done_sz * 4) - PIC_PIB_DATA_OFFSET_FROM_END;
+	res = copy_from_user(dio->pib_va, (void *)(dio->uinfo.xfr_buff + offset), 4);
+	if (res != 0)
+		goto getpictureinfo_err;
+	PicInfoLineNum = *(uint32_t*)(dio->pib_va);
+	if (PicInfoLineNum > 1092) {
+		dev_err(dev, "Invalid Line Number[%x], DoneSz:0x%x Bytes\n",
+			(int)PicInfoLineNum, rx_pkt->dio_req->uinfo.y_done_sz * 4);
+		goto getpictureinfo_err;
+	}
+
+	offset = (rx_pkt->dio_req->uinfo.y_done_sz * 4) - PIC_WIDTH_OFFSET_FROM_END;
+	res = copy_from_user(dio->pib_va, (void *)(dio->uinfo.xfr_buff + offset), 4);
+	if (res != 0)
+		goto getpictureinfo_err;
+	widthField = *(uint32_t*)(dio->pib_va);
+
+	hw->PICWidth = widthField & 0x3FFFFFFF; /* bit 31 is FMT Change, bit 30 is EOS */
+	if (hw->PICWidth > 2048) {
+		dev_err(dev, "Invalid width [%d]\n", hw->PICWidth);
+		goto getpictureinfo_err;
+	}
+
+	/* calc pic info line offset */
+	if (dio->uinfo.b422mode) {
+		size = 2 * sizeof(struct BC_PIC_INFO_BLOCK);
+		offset = (PicInfoLineNum * hw->PICWidth * 2) + 4;
+	} else {
+		size = sizeof(struct BC_PIC_INFO_BLOCK);
+		offset = (PicInfoLineNum * hw->PICWidth) + 4;
+	}
+
+	res = copy_from_user(tmpPicInfo, (void *)(dio->uinfo.xfr_buff+offset), size);
+	if (res != 0)
+		goto getpictureinfo_err;
+
+	pPicInfoLine = (struct BC_PIC_INFO_BLOCK *)(tmpPicInfo);
+
+	*PicMetaData = pPicInfoLine->timeStamp;
+
+	if(widthField & PIB_EOS_DETECTED_BIT)
+	{
+		dev_dbg(dev, "Got EOS flag.\n");
+		hw->DrvEosDetected = 1;
+		*(uint32_t *)(dio->pib_va) = 0xFFFFFFFF;
+		res = copy_to_user((void *)(dio->uinfo.xfr_buff), dio->pib_va, 4);
+		if (res != 0)
+			goto getpictureinfo_err;
+	}
+	else
+	{
+		if( hw->DrvEosDetected == 1 )
+			hw->DrvCancelEosFlag = 1;
+
+		hw->DrvEosDetected = 0;
+		res = copy_from_user(dio->pib_va, (void *)(dio->uinfo.xfr_buff), 4);
+		if (res != 0)
+			goto getpictureinfo_err;
+
+		tmpYBuffData = *(uint32_t *)(dio->pib_va);
+		pPicInfoLine->ycom = tmpYBuffData;
+		res = copy_to_user((void *)(dio->uinfo.xfr_buff+offset), tmpPicInfo, size);
+		if (res != 0)
+			goto getpictureinfo_err;
+
+		*(uint32_t *)(dio->pib_va) = PicInfoLineNum;
+		res = copy_to_user((void *)(dio->uinfo.xfr_buff), dio->pib_va, 4);
+		if (res != 0)
+			goto getpictureinfo_err;
+	}
+
+	if(widthField & PIB_FORMAT_CHANGE_BIT)
+	{
+		rx_pkt->flags = 0;
+		rx_pkt->flags |= COMP_FLAG_PIB_VALID | COMP_FLAG_FMT_CHANGE;
+
+		rx_pkt->pib.picture_number			= pPicInfoLine->picture_number;
+		rx_pkt->pib.width					= pPicInfoLine->width;
+		rx_pkt->pib.height					= pPicInfoLine->height;
+		rx_pkt->pib.chroma_format			= pPicInfoLine->chroma_format;
+		rx_pkt->pib.pulldown				= pPicInfoLine->pulldown;
+		rx_pkt->pib.flags					= pPicInfoLine->flags;
+		rx_pkt->pib.sess_num				= pPicInfoLine->sess_num;
+		rx_pkt->pib.aspect_ratio			= pPicInfoLine->aspect_ratio;
+		rx_pkt->pib.colour_primaries		= pPicInfoLine->colour_primaries;
+		rx_pkt->pib.picture_meta_payload	= pPicInfoLine->picture_meta_payload;
+		rx_pkt->pib.frame_rate				= pPicInfoLine->frame_rate;
+		rx_pkt->pib.custom_aspect_ratio_width_height = pPicInfoLine->custom_aspect_ratio_width_height;
+		rx_pkt->pib.n_drop				= pPicInfoLine->n_drop;
+		rx_pkt->pib.ycom				= pPicInfoLine->ycom;
+		hw->PICHeight = rx_pkt->pib.height;
+		hw->PICWidth = rx_pkt->pib.width;
+		hw->LastPicNo=0;
+		hw->LastTwoPicNo=0;
+		hw->PDRatio = 0; /* NAREN - reset PD ratio to start measuring for new clip */
+		hw->PauseThreshold = hw->DefaultPauseThreshold;
+		hw->TickSpentInPD = 0;
+		rdtscll(hw->TickCntDecodePU);
+
+		dev_dbg(dev, "[FMT CH] DoneSz:0x%x, PIB:%x %x %x %x %x %x %x %x %x %x\n",
+			rx_pkt->dio_req->uinfo.y_done_sz * 4,
+				 rx_pkt->pib.picture_number,
+				 rx_pkt->pib.aspect_ratio,
+				 rx_pkt->pib.chroma_format,
+				 rx_pkt->pib.colour_primaries,
+				 rx_pkt->pib.frame_rate,
+				 rx_pkt->pib.height,
+				 rx_pkt->pib.width,
+				 rx_pkt->pib.n_drop,
+				 rx_pkt->pib.pulldown,
+				 rx_pkt->pib.ycom);
+		rtVal = false;
+	}
+
+	if(pPicInfoLine->flags & FLEA_DECODE_ERROR_FLAG)
+	{
+		*PicNumber = 0;
+	} else {
+		/* get pic number and flags */
+		if (dio->uinfo.b422mode)
+			offset = (PicInfoLineNum * hw->PICWidth * 2);
+		else
+			offset = (PicInfoLineNum * hw->PICWidth);
+
+		res = copy_from_user(dio->pib_va, (void *)(dio->uinfo.xfr_buff+offset), 4);
+		if (res != 0)
+			goto getpictureinfo_err;
+
+		*PicNumber = *(uint32_t *)(dio->pib_va);
+	}
+
+	if(dio->pib_va)
+		kfree(dio->pib_va);
+	if(tmpPicInfo)
+		kfree(tmpPicInfo);
+
+/*	up(&hw->fetch_sem); */
+
+	return rtVal;
+
+getpictureinfo_err:
+/*	up(&hw->fetch_sem); */
+
+getpictureinfo_err_nosem:
+	if(dio->pib_va)
+		kfree(dio->pib_va);
+	if(tmpPicInfo)
+		kfree(tmpPicInfo);
+
+	*PicNumber = 0;
+	*PicMetaData = 0;
+
+	return false;
+}
+
+uint32_t flea_GetRptDropParam(struct crystalhd_hw *hw, void* pRxDMAReq)
+{
+	uint32_t PicNumber = 0,result = 0;
+	uint64_t PicMetaData = 0;
+
+	if(flea_GetPictureInfo(hw, (struct crystalhd_rx_dma_pkt *)pRxDMAReq,
+		&PicNumber, &PicMetaData))
+		result = PicNumber;
+
+	return result;
+}
+
+bool crystalhd_flea_notify_event(struct crystalhd_hw *hw, enum BRCM_EVENT EventCode)
+{
+	switch(EventCode)
+	{
+		case BC_EVENT_START_CAPTURE:
+		{
+			crystalhd_flea_wake_up_hw(hw);
+			break;
+		}
+		default:
+			break;
+	}
+
+	return true;
+}
diff --git a/drivers/staging/crystalhd/crystalhd_fleafuncs.h b/drivers/staging/crystalhd/crystalhd_fleafuncs.h
new file mode 100644
index 0000000..5378f9e
--- /dev/null
+++ b/drivers/staging/crystalhd/crystalhd_fleafuncs.h
@@ -0,0 +1,62 @@
+/***************************************************************************
+ * Copyright (c) 2005-2009, Broadcom Corporation.
+ *
+ *  Name: crystalhd_fleafuncs . h
+ *
+ *  Description:
+ *		BCM70015 Linux driver hardware layer.
+ *
+ *  HISTORY:
+ *
+ **********************************************************************
+ * This file is part of the crystalhd device driver.
+ *
+ * This driver is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * This driver is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this driver.  If not, see <http://www.gnu.org/licenses/>.
+ **********************************************************************/
+
+#ifndef _CRYSTALHD_FLEAFUNCS_H_
+#define _CRYSTALHD_FLEAFUNCS_H_
+
+#include "FleaDefs.h"
+
+#define FW_CMD_BUFF_SZ		64
+
+bool crystalhd_flea_start_device(struct crystalhd_hw *hw);
+bool crystalhd_flea_stop_device(struct crystalhd_hw *hw);
+bool crystalhd_flea_hw_interrupt_handle(struct crystalhd_adp *adp, struct crystalhd_hw *hw);
+uint32_t crystalhd_flea_reg_rd(struct crystalhd_adp *adp, uint32_t reg_off);											/* Done */
+void crystalhd_flea_reg_wr(struct crystalhd_adp *adp, uint32_t reg_off, uint32_t val);									/* Done */
+bool crystalhd_flea_check_input_full(struct crystalhd_hw *hw, uint32_t needed_sz, uint32_t *empty_sz, bool b_188_byte_pkts, uint8_t *flags);
+enum BC_STATUS crystalhd_flea_mem_rd(struct crystalhd_hw *hw, uint32_t start_off, uint32_t dw_cnt, uint32_t *rd_buff);		/* Done */
+enum BC_STATUS crystalhd_flea_mem_wr(struct crystalhd_hw *hw, uint32_t start_off, uint32_t dw_cnt, uint32_t *wr_buff);		/* Done */
+enum BC_STATUS crystalhd_flea_do_fw_cmd(struct crystalhd_hw *hw, struct BC_FW_CMD *fw_cmd);
+enum BC_STATUS crystalhd_flea_download_fw(struct crystalhd_hw* hw, uint8_t* buffer, uint32_t sz);
+void crystalhd_flea_get_dnsz(struct crystalhd_hw *hw, uint32_t list_index, uint32_t *y_dw_dnsz, uint32_t *uv_dw_dnsz);
+enum BC_STATUS crystalhd_flea_hw_pause(struct crystalhd_hw *hw, bool state);
+bool crystalhd_flea_peek_next_decoded_frame(struct crystalhd_hw *hw, uint64_t *meta_payload, uint32_t *picNumFlags, uint32_t PicWidth);
+enum BC_STATUS crystalhd_flea_hw_post_cap_buff(struct crystalhd_hw *hw, struct crystalhd_rx_dma_pkt *rx_pkt);
+void crystalhd_flea_start_tx_dma_engine(struct crystalhd_hw *hw, uint8_t list_id, addr_64 desc_addr);
+void crystalhd_flea_stop_rx_dma_engine(struct crystalhd_hw *hw);
+enum BC_STATUS crystalhd_flea_stop_tx_dma_engine(struct crystalhd_hw *hw);
+bool crystalhd_flea_tx_list0_handler(struct crystalhd_hw *hw, uint32_t err_sts);
+bool crystalhd_flea_tx_list1_handler(struct crystalhd_hw *hw, uint32_t err_sts);
+void crystalhd_flea_tx_isr(struct crystalhd_hw *hw, union FLEA_INTR_BITS_COMMON int_sts);
+bool crystalhd_flea_rx_list0_handler(struct crystalhd_hw *hw,union FLEA_INTR_BITS_COMMON int_sts,uint32_t y_err_sts,uint32_t uv_err_sts);
+bool crystalhd_flea_rx_list1_handler(struct crystalhd_hw *hw,union FLEA_INTR_BITS_COMMON int_sts,uint32_t y_err_sts,uint32_t uv_err_sts);
+void crystalhd_flea_rx_isr(struct crystalhd_hw *hw, union FLEA_INTR_BITS_COMMON intr_sts);
+void crystalhd_flea_notify_fll_change(struct crystalhd_hw *hw, bool bCleanupContext);
+bool crystalhd_flea_notify_event(struct crystalhd_hw *hw, enum BRCM_EVENT EventCode);
+
+bool flea_GetPictureInfo(struct crystalhd_hw *hw, struct crystalhd_rx_dma_pkt * rx_pkt,
+						 uint32_t *PicNumber, uint64_t *PicMetaData);
+#endif
diff --git a/drivers/staging/crystalhd/crystalhd_fw_if.h b/drivers/staging/crystalhd/crystalhd_fw_if.h
index 4b363a5..67a29c8 100644
--- a/drivers/staging/crystalhd/crystalhd_fw_if.h
+++ b/drivers/staging/crystalhd/crystalhd_fw_if.h
@@ -27,21 +27,23 @@
 #ifndef _CRYSTALHD_FW_IF_H_
 #define _CRYSTALHD_FW_IF_H_
 
+#include <linux/types.h>
+
 /* TBD: Pull in only required defs into this file.. */
 
 /* User Data Header */
 struct user_data {
-	struct user_data	*next;
-	uint32_t		type;
-	uint32_t		size;
+        struct user_data	*next;
+        uint32_t		type;
+        uint32_t		size;
 };
 
 /*------------------------------------------------------*
  *    MPEG Extension to the PPB			 *
  *------------------------------------------------------*/
 struct ppb_mpeg {
-	uint32_t		to_be_defined;
-	uint32_t		valid;
+        uint32_t		to_be_defined;
+        uint32_t		valid;
 
 	/* Always valid, defaults to picture size if no
 	   sequence display extension in the stream. */
@@ -54,10 +56,10 @@ struct ppb_mpeg {
 	int32_t		horizontal_offset[3];
 	int32_t		vertical_offset[3];
 
-	/* MPEG_VALID_USERDATA
-	   User data is in the form of a linked list. */
-	int32_t		userDataSize;
-	struct user_data	*userData;
+        /* MPEG_VALID_USERDATA
+           User data is in the form of a linked list. */
+        int32_t		userDataSize;
+        struct user_data		*userData;
 
 };
 
@@ -66,8 +68,8 @@ struct ppb_mpeg {
  *    VC1 Extension to the PPB			  *
  *------------------------------------------------------*/
 struct ppb_vc1 {
-	uint32_t		to_be_defined;
-	uint32_t		valid;
+        uint32_t		to_be_defined;
+        uint32_t		valid;
 
 	/* Always valid, defaults to picture size if no
 	   sequence display extension in the stream. */
@@ -81,10 +83,10 @@ struct ppb_vc1 {
 	int32_t		ps_width[4];
 	int32_t		ps_height[4];
 
-	/* VC1_VALID_USERDATA
-	   User data is in the form of a linked list. */
-	int32_t		userDataSize;
-	struct user_data	*userData;
+        /* VC1_VALID_USERDATA
+           User data is in the form of a linked list. */
+        int32_t		userDataSize;
+        struct user_data	*userData;
 
 };
 
@@ -234,6 +236,11 @@ struct c011_pib {
 
 };
 
+struct C011_TS_CMD {
+	uint32_t	eCmd; /* eC011_TS_CMD */
+	uint32_t	ulParams[63];
+};
+
 struct dec_rsp_channel_start_video {
 	uint32_t	command;
 	uint32_t	sequence;
@@ -247,7 +254,22 @@ struct dec_rsp_channel_start_video {
 	uint32_t	userDataReleaseQ;
 	uint32_t	transportStreamCaptureAddr;
 	uint32_t	asyncEventQ;
+};
 
+struct dec_rsp_channel_channel_open {
+	uint32_t command;
+	uint32_t sequence;
+	uint32_t status;
+	uint32_t ChannelID;
+	uint32_t picBuf;
+	uint32_t picRelBuf;
+	uint32_t picInfoDeliveryQ;
+	uint32_t picInfoReleaseQ;
+	uint32_t channelStatus;
+	uint32_t userDataDeliveryQ;
+	uint32_t userDataReleaseQ;
+	uint32_t transportStreamCaptureAddr;
+	uint32_t asyncEventQ;
 };
 
 #define eCMD_C011_CMD_BASE	  (0x73763000)
diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
index 5845e89..f33cc7d 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.c
+++ b/drivers/staging/crystalhd/crystalhd_hw.c
@@ -4,7 +4,9 @@
  *  Name: crystalhd_hw . c
  *
  *  Description:
- *		BCM70010 Linux driver HW layer.
+ *		BCM70012/BCM70015 Linux driver hardware layer.
+ *
+ *  HISTORY:
  *
  **********************************************************************
  * This file is part of the crystalhd device driver.
@@ -25,341 +27,121 @@
 #include "crystalhd.h"
 
 #include <linux/pci.h>
-#include <linux/slab.h>
 #include <linux/delay.h>
+#include <linux/device.h>
+#include <asm/tsc.h>
+#include <asm/msr.h>
 
-/* Functions internal to this file */
-
-static void crystalhd_enable_uarts(struct crystalhd_adp *adp)
-{
-	bc_dec_reg_wr(adp, UartSelectA, BSVS_UART_STREAM);
-	bc_dec_reg_wr(adp, UartSelectB, BSVS_UART_DEC_OUTER);
-}
-
-
-static void crystalhd_start_dram(struct crystalhd_adp *adp)
-{
-	bc_dec_reg_wr(adp, SDRAM_PARAM, ((40 / 5 - 1) <<  0) |
-	/* tras (40ns tras)/(5ns period) -1 ((15/5 - 1) <<  4) | // trcd */
-		      ((15 / 5 - 1) <<  7) |	/* trp */
-		      ((10 / 5 - 1) << 10) |	/* trrd */
-		      ((15 / 5 + 1) << 12) |	/* twr */
-		      ((2 + 1) << 16) |		/* twtr */
-		      ((70 / 5 - 2) << 19) |	/* trfc */
-		      (0 << 23));
-
-	bc_dec_reg_wr(adp, SDRAM_PRECHARGE, 0);
-	bc_dec_reg_wr(adp, SDRAM_EXT_MODE, 2);
-	bc_dec_reg_wr(adp, SDRAM_MODE, 0x132);
-	bc_dec_reg_wr(adp, SDRAM_PRECHARGE, 0);
-	bc_dec_reg_wr(adp, SDRAM_REFRESH, 0);
-	bc_dec_reg_wr(adp, SDRAM_REFRESH, 0);
-	bc_dec_reg_wr(adp, SDRAM_MODE, 0x32);
-	/* setting the refresh rate here */
-	bc_dec_reg_wr(adp, SDRAM_REF_PARAM, ((1 << 12) | 96));
-}
-
-
-static bool crystalhd_bring_out_of_rst(struct crystalhd_adp *adp)
-{
-	union link_misc_perst_deco_ctrl rst_deco_cntrl;
-	union link_misc_perst_clk_ctrl rst_clk_cntrl;
-	uint32_t temp;
-
-	/*
-	 * Link clocks: MISC_PERST_CLOCK_CTRL Clear PLL power down bit,
-	 * delay to allow PLL to lock Clear alternate clock, stop clock bits
-	 */
-	rst_clk_cntrl.whole_reg = crystalhd_reg_rd(adp, MISC_PERST_CLOCK_CTRL);
-	rst_clk_cntrl.pll_pwr_dn = 0;
-	crystalhd_reg_wr(adp, MISC_PERST_CLOCK_CTRL, rst_clk_cntrl.whole_reg);
-	msleep_interruptible(50);
-
-	rst_clk_cntrl.whole_reg = crystalhd_reg_rd(adp, MISC_PERST_CLOCK_CTRL);
-	rst_clk_cntrl.stop_core_clk = 0;
-	rst_clk_cntrl.sel_alt_clk = 0;
-
-	crystalhd_reg_wr(adp, MISC_PERST_CLOCK_CTRL, rst_clk_cntrl.whole_reg);
-	msleep_interruptible(50);
-
-	/*
-	 * Bus Arbiter Timeout: GISB_ARBITER_TIMER
-	 * Set internal bus arbiter timeout to 40us based on core clock speed
-	 * (63MHz * 40us = 0x9D8)
-	 */
-	crystalhd_reg_wr(adp, GISB_ARBITER_TIMER, 0x9D8);
-
-	/*
-	 * Decoder clocks: MISC_PERST_DECODER_CTRL
-	 * Enable clocks while 7412 reset is asserted, delay
-	 * De-assert 7412 reset
-	 */
-	rst_deco_cntrl.whole_reg = crystalhd_reg_rd(adp,
-					 MISC_PERST_DECODER_CTRL);
-	rst_deco_cntrl.stop_bcm_7412_clk = 0;
-	rst_deco_cntrl.bcm7412_rst = 1;
-	crystalhd_reg_wr(adp, MISC_PERST_DECODER_CTRL,
-					 rst_deco_cntrl.whole_reg);
-	msleep_interruptible(10);
-
-	rst_deco_cntrl.whole_reg = crystalhd_reg_rd(adp,
-					 MISC_PERST_DECODER_CTRL);
-	rst_deco_cntrl.bcm7412_rst = 0;
-	crystalhd_reg_wr(adp, MISC_PERST_DECODER_CTRL,
-					 rst_deco_cntrl.whole_reg);
-	msleep_interruptible(50);
-
-	/* Disable OTP_CONTENT_MISC to 0 to disable all secure modes */
-	crystalhd_reg_wr(adp, OTP_CONTENT_MISC, 0);
-
-	/* Clear bit 29 of 0x404 */
-	temp = crystalhd_reg_rd(adp, PCIE_TL_TRANSACTION_CONFIGURATION);
-	temp &= ~BC_BIT(29);
-	crystalhd_reg_wr(adp, PCIE_TL_TRANSACTION_CONFIGURATION, temp);
-
-	/* 2.5V regulator must be set to 2.6 volts (+6%) */
-	/* FIXME: jarod: what's the point of this reg read? */
-	temp = crystalhd_reg_rd(adp, MISC_PERST_VREG_CTRL);
-	crystalhd_reg_wr(adp, MISC_PERST_VREG_CTRL, 0xF3);
-
-	return true;
-}
-
-static bool crystalhd_put_in_reset(struct crystalhd_adp *adp)
-{
-	union link_misc_perst_deco_ctrl rst_deco_cntrl;
-	union link_misc_perst_clk_ctrl  rst_clk_cntrl;
-	uint32_t                  temp;
-
-	/*
-	 * Decoder clocks: MISC_PERST_DECODER_CTRL
-	 * Assert 7412 reset, delay
-	 * Assert 7412 stop clock
-	 */
-	rst_deco_cntrl.whole_reg = crystalhd_reg_rd(adp,
-					 MISC_PERST_DECODER_CTRL);
-	rst_deco_cntrl.stop_bcm_7412_clk = 1;
-	crystalhd_reg_wr(adp, MISC_PERST_DECODER_CTRL,
-					 rst_deco_cntrl.whole_reg);
-	msleep_interruptible(50);
-
-	/* Bus Arbiter Timeout: GISB_ARBITER_TIMER
-	 * Set internal bus arbiter timeout to 40us based on core clock speed
-	 * (6.75MHZ * 40us = 0x10E)
-	 */
-	crystalhd_reg_wr(adp, GISB_ARBITER_TIMER, 0x10E);
-
-	/* Link clocks: MISC_PERST_CLOCK_CTRL
-	 * Stop core clk, delay
-	 * Set alternate clk, delay, set PLL power down
-	 */
-	rst_clk_cntrl.whole_reg = crystalhd_reg_rd(adp, MISC_PERST_CLOCK_CTRL);
-	rst_clk_cntrl.stop_core_clk = 1;
-	rst_clk_cntrl.sel_alt_clk = 1;
-	crystalhd_reg_wr(adp, MISC_PERST_CLOCK_CTRL, rst_clk_cntrl.whole_reg);
-	msleep_interruptible(50);
-
-	rst_clk_cntrl.whole_reg = crystalhd_reg_rd(adp, MISC_PERST_CLOCK_CTRL);
-	rst_clk_cntrl.pll_pwr_dn = 1;
-	crystalhd_reg_wr(adp, MISC_PERST_CLOCK_CTRL, rst_clk_cntrl.whole_reg);
+#include "crystalhd_linkfuncs.h"
+#include "crystalhd_fleafuncs.h"
 
-	/*
-	 * Read and restore the Transaction Configuration Register
-	 * after core reset
-	 */
-	temp = crystalhd_reg_rd(adp, PCIE_TL_TRANSACTION_CONFIGURATION);
-
-	/*
-	 * Link core soft reset: MISC3_RESET_CTRL
-	 * - Write BIT[0]=1 and read it back for core reset to take place
-	 */
-	crystalhd_reg_wr(adp, MISC3_RESET_CTRL, 1);
-	rst_deco_cntrl.whole_reg = crystalhd_reg_rd(adp, MISC3_RESET_CTRL);
-	msleep_interruptible(50);
-
-	/* restore the transaction configuration register */
-	crystalhd_reg_wr(adp, PCIE_TL_TRANSACTION_CONFIGURATION, temp);
-
-	return true;
-}
-
-static void crystalhd_disable_interrupts(struct crystalhd_adp *adp)
-{
-	union intr_mask_reg   intr_mask;
-	intr_mask.whole_reg = crystalhd_reg_rd(adp, INTR_INTR_MSK_STS_REG);
-	intr_mask.mask_pcie_err = 1;
-	intr_mask.mask_pcie_rbusmast_err = 1;
-	intr_mask.mask_pcie_rgr_bridge   = 1;
-	intr_mask.mask_rx_done = 1;
-	intr_mask.mask_rx_err  = 1;
-	intr_mask.mask_tx_done = 1;
-	intr_mask.mask_tx_err  = 1;
-	crystalhd_reg_wr(adp, INTR_INTR_MSK_SET_REG, intr_mask.whole_reg);
-
-	return;
-}
-
-static void crystalhd_enable_interrupts(struct crystalhd_adp *adp)
-{
-	union intr_mask_reg   intr_mask;
-	intr_mask.whole_reg = crystalhd_reg_rd(adp, INTR_INTR_MSK_STS_REG);
-	intr_mask.mask_pcie_err = 1;
-	intr_mask.mask_pcie_rbusmast_err = 1;
-	intr_mask.mask_pcie_rgr_bridge   = 1;
-	intr_mask.mask_rx_done = 1;
-	intr_mask.mask_rx_err  = 1;
-	intr_mask.mask_tx_done = 1;
-	intr_mask.mask_tx_err  = 1;
-	crystalhd_reg_wr(adp, INTR_INTR_MSK_CLR_REG, intr_mask.whole_reg);
-
-	return;
-}
-
-static void crystalhd_clear_errors(struct crystalhd_adp *adp)
-{
-	uint32_t reg;
-
-	/* FIXME: jarod: wouldn't we want to write a 0 to the reg?
-	 Or does the write clear the bits specified? */
-	reg = crystalhd_reg_rd(adp, MISC1_Y_RX_ERROR_STATUS);
-	if (reg)
-		crystalhd_reg_wr(adp, MISC1_Y_RX_ERROR_STATUS, reg);
-
-	reg = crystalhd_reg_rd(adp, MISC1_UV_RX_ERROR_STATUS);
-	if (reg)
-		crystalhd_reg_wr(adp, MISC1_UV_RX_ERROR_STATUS, reg);
-
-	reg = crystalhd_reg_rd(adp, MISC1_TX_DMA_ERROR_STATUS);
-	if (reg)
-		crystalhd_reg_wr(adp, MISC1_TX_DMA_ERROR_STATUS, reg);
-}
-
-static void crystalhd_clear_interrupts(struct crystalhd_adp *adp)
-{
-	uint32_t intr_sts = crystalhd_reg_rd(adp, INTR_INTR_STATUS);
-
-	if (intr_sts) {
-		crystalhd_reg_wr(adp, INTR_INTR_CLR_REG, intr_sts);
-
-		/* Write End Of Interrupt for PCIE */
-		crystalhd_reg_wr(adp, INTR_EOI_CTRL, 1);
-	}
-}
-
-static void crystalhd_soft_rst(struct crystalhd_adp *adp)
-{
-	uint32_t val;
-
-	/* Assert c011 soft reset*/
-	bc_dec_reg_wr(adp, DecHt_HostSwReset, 0x00000001);
-	msleep_interruptible(50);
-
-	/* Release c011 soft reset*/
-	bc_dec_reg_wr(adp, DecHt_HostSwReset, 0x00000000);
-
-	/* Disable Stuffing..*/
-	val = crystalhd_reg_rd(adp, MISC2_GLOBAL_CTRL);
-	val |= BC_BIT(8);
-	crystalhd_reg_wr(adp, MISC2_GLOBAL_CTRL, val);
-}
+#define OFFSETOF(_s_, _m_) ((size_t)(unsigned long)&(((_s_ *)0)->_m_))
 
-static bool crystalhd_load_firmware_config(struct crystalhd_adp *adp)
+enum BC_STATUS crystalhd_hw_open(struct crystalhd_hw *hw, struct crystalhd_adp *adp)
 {
-	uint32_t i = 0, reg;
-
-	crystalhd_reg_wr(adp, DCI_DRAM_BASE_ADDR, (BC_DRAM_FW_CFG_ADDR >> 19));
-
-	crystalhd_reg_wr(adp, AES_CMD, 0);
-	crystalhd_reg_wr(adp, AES_CONFIG_INFO,
-		 (BC_DRAM_FW_CFG_ADDR & 0x7FFFF));
-	crystalhd_reg_wr(adp, AES_CMD, 0x1);
-
-	/* FIXME: jarod: I've seen this fail,
-	 and introducing extra delays helps... */
-	for (i = 0; i < 100; ++i) {
-		reg = crystalhd_reg_rd(adp, AES_STATUS);
-		if (reg & 0x1)
-			return true;
-		msleep_interruptible(10);
+	struct device *dev;
+	if (!hw || !adp) {
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
+		return BC_STS_INV_ARG;
 	}
 
-	return false;
-}
-
-
-static bool crystalhd_start_device(struct crystalhd_adp *adp)
-{
-	uint32_t dbg_options, glb_cntrl = 0, reg_pwrmgmt = 0;
-
-	BCMLOG(BCMLOG_INFO, "Starting BCM70012 Device\n");
-
-	reg_pwrmgmt = crystalhd_reg_rd(adp, PCIE_DLL_DATA_LINK_CONTROL);
-	reg_pwrmgmt &= ~ASPM_L1_ENABLE;
-
-	crystalhd_reg_wr(adp, PCIE_DLL_DATA_LINK_CONTROL, reg_pwrmgmt);
+	if (hw->dev_started)
+		return BC_STS_SUCCESS;
 
-	if (!crystalhd_bring_out_of_rst(adp)) {
-		BCMLOG_ERR("Failed To Bring Link Out Of Reset\n");
-		return false;
+	dev = &adp->pdev->dev;
+	hw->PauseThreshold = BC_RX_LIST_CNT - 2;
+	hw->DefaultPauseThreshold = BC_RX_LIST_CNT - 2;
+	hw->ResumeThreshold = 3;
+
+	/* Setup HW specific functions appropriately */
+	if (adp->pdev->device == BC_PCI_DEVID_FLEA) {
+		dev_dbg(dev, "crystalhd_hw_open: setting up functions, device = Flea\n");
+		hw->pfnStartDevice = crystalhd_flea_start_device;
+		hw->pfnStopDevice = crystalhd_flea_stop_device;
+		hw->pfnFindAndClearIntr = crystalhd_flea_hw_interrupt_handle;
+		hw->pfnReadDevRegister = crystalhd_flea_reg_rd;					/* Done */
+		hw->pfnWriteDevRegister = crystalhd_flea_reg_wr;				/* Done */
+		hw->pfnReadFPGARegister = crystalhd_flea_reg_rd;				/* Done */
+		hw->pfnWriteFPGARegister = crystalhd_flea_reg_wr;				/* Done */
+		hw->pfnCheckInputFIFO = crystalhd_flea_check_input_full;
+		hw->pfnDevDRAMRead = crystalhd_flea_mem_rd;						/* Done */
+		hw->pfnDevDRAMWrite = crystalhd_flea_mem_wr;					/* Done */
+		hw->pfnDoFirmwareCmd = crystalhd_flea_do_fw_cmd;
+		hw->pfnFWDwnld = crystalhd_flea_download_fw;
+		hw->pfnHWGetDoneSize = crystalhd_flea_get_dnsz;
+		hw->pfnIssuePause = crystalhd_flea_hw_pause;
+		hw->pfnPeekNextDeodedFr = crystalhd_flea_peek_next_decoded_frame;
+		hw->pfnPostRxSideBuff = crystalhd_flea_hw_post_cap_buff;
+		hw->pfnStartTxDMA = crystalhd_flea_start_tx_dma_engine;
+		hw->pfnStopTxDMA = crystalhd_flea_stop_tx_dma_engine;
+		hw->pfnStopRXDMAEngines = crystalhd_flea_stop_rx_dma_engine;
+		hw->pfnNotifyFLLChange = crystalhd_flea_notify_fll_change;
+		hw->pfnNotifyHardware = crystalhd_flea_notify_event;
+	} else {
+		dev_dbg(dev, "crystalhd_hw_open: setting up functions, device = Link\n");
+		hw->pfnStartDevice = crystalhd_link_start_device;
+		hw->pfnStopDevice = crystalhd_link_stop_device;
+		hw->pfnFindAndClearIntr = crystalhd_link_hw_interrupt_handle;
+		hw->pfnReadDevRegister = link_dec_reg_rd;
+		hw->pfnWriteDevRegister = link_dec_reg_wr;
+		hw->pfnReadFPGARegister = crystalhd_link_reg_rd;
+		hw->pfnWriteFPGARegister = crystalhd_link_reg_wr;
+		hw->pfnCheckInputFIFO = crystalhd_link_check_input_full;
+		hw->pfnDevDRAMRead = crystalhd_link_mem_rd;
+		hw->pfnDevDRAMWrite = crystalhd_link_mem_wr;
+		hw->pfnDoFirmwareCmd = crystalhd_link_do_fw_cmd;
+		hw->pfnFWDwnld = crystalhd_link_download_fw;
+		hw->pfnHWGetDoneSize = crystalhd_link_get_dnsz;
+		hw->pfnIssuePause = crystalhd_link_hw_pause;
+		hw->pfnPeekNextDeodedFr = crystalhd_link_peek_next_decoded_frame;
+		hw->pfnPostRxSideBuff = crystalhd_link_hw_post_cap_buff;
+		hw->pfnStartTxDMA = crystalhd_link_start_tx_dma_engine;
+		hw->pfnStopTxDMA = crystalhd_link_stop_tx_dma_engine;
+		hw->pfnStopRXDMAEngines = crystalhd_link_stop_rx_dma_engine;
+		hw->pfnNotifyFLLChange = crystalhd_link_notify_fll_change;
+		hw->pfnNotifyHardware = crystalhd_link_notify_event;
 	}
 
-	crystalhd_disable_interrupts(adp);
-
-	crystalhd_clear_errors(adp);
-
-	crystalhd_clear_interrupts(adp);
-
-	crystalhd_enable_interrupts(adp);
-
-	/* Enable the option for getting the total no. of DWORDS
-	 * that have been transferred by the RXDMA engine
-	 */
-	dbg_options = crystalhd_reg_rd(adp, MISC1_DMA_DEBUG_OPTIONS_REG);
-	dbg_options |= 0x10;
-	crystalhd_reg_wr(adp, MISC1_DMA_DEBUG_OPTIONS_REG, dbg_options);
+	hw->adp = adp;
+	spin_lock_init(&hw->lock);
+	spin_lock_init(&hw->rx_lock);
+	sema_init(&hw->fetch_sem, 1);
 
-	/* Enable PCI Global Control options */
-	glb_cntrl = crystalhd_reg_rd(adp, MISC2_GLOBAL_CTRL);
-	glb_cntrl |= 0x100;
-	glb_cntrl |= 0x8000;
-	crystalhd_reg_wr(adp, MISC2_GLOBAL_CTRL, glb_cntrl);
+	/* Seed for error checking and debugging. Random numbers */
+	hw->tx_ioq_tag_seed = 0x70023070;
+	hw->rx_pkt_tag_seed = 0x70029070;
 
-	crystalhd_enable_interrupts(adp);
+	hw->stop_pending = 0;
+	hw->pfnStartDevice(hw);
+	hw->dev_started = true;
 
-	crystalhd_soft_rst(adp);
-	crystalhd_start_dram(adp);
-	crystalhd_enable_uarts(adp);
+	dev_dbg(dev, "Opening HW. hw:0x%lx, hw->adp:0x%lx\n",
+		(uintptr_t)hw, (uintptr_t)(hw->adp));
 
-	return true;
+	return BC_STS_SUCCESS;
 }
 
-static bool crystalhd_stop_device(struct crystalhd_adp *adp)
+enum BC_STATUS crystalhd_hw_close(struct crystalhd_hw *hw, struct crystalhd_adp *adp)
 {
-	uint32_t reg;
-
-	BCMLOG(BCMLOG_INFO, "Stopping BCM70012 Device\n");
-	/* Clear and disable interrupts */
-	crystalhd_disable_interrupts(adp);
-	crystalhd_clear_errors(adp);
-	crystalhd_clear_interrupts(adp);
+	if (!hw) {
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
+		return BC_STS_SUCCESS;
+	}
 
-	if (!crystalhd_put_in_reset(adp))
-		BCMLOG_ERR("Failed to Put Link To Reset State\n");
+	if (!hw->dev_started)
+		return BC_STS_SUCCESS;
 
-	reg = crystalhd_reg_rd(adp, PCIE_DLL_DATA_LINK_CONTROL);
-	reg |= ASPM_L1_ENABLE;
-	crystalhd_reg_wr(adp, PCIE_DLL_DATA_LINK_CONTROL, reg);
+	/* Stop and DDR sleep will happen in here */
+	/* Only stop the HW if we are the last user */
+	if(adp->cfg_users == 1)
+		crystalhd_hw_suspend(hw);
 
-	/* Set PCI Clk Req */
-	reg = crystalhd_reg_rd(adp, PCIE_CLK_REQ_REG);
-	reg |= PCI_CLK_REQ_ENABLE;
-	crystalhd_reg_wr(adp, PCIE_CLK_REQ_REG, reg);
+	hw->dev_started = false;
 
-	return true;
+	return BC_STS_SUCCESS;
 }
 
-static struct crystalhd_rx_dma_pkt *crystalhd_hw_alloc_rx_pkt(
-					struct crystalhd_hw *hw)
+struct crystalhd_rx_dma_pkt *crystalhd_hw_alloc_rx_pkt(struct crystalhd_hw *hw)
 {
 	unsigned long flags = 0;
 	struct crystalhd_rx_dma_pkt *temp = NULL;
@@ -380,7 +162,7 @@ static struct crystalhd_rx_dma_pkt *crystalhd_hw_alloc_rx_pkt(
 	return temp;
 }
 
-static void crystalhd_hw_free_rx_pkt(struct crystalhd_hw *hw,
+void crystalhd_hw_free_rx_pkt(struct crystalhd_hw *hw,
 				   struct crystalhd_rx_dma_pkt *pkt)
 {
 	unsigned long flags = 0;
@@ -403,7 +185,7 @@ static void crystalhd_hw_free_rx_pkt(struct crystalhd_hw *hw,
  * Memory is allocated per DMA ring basis. This is just
  * a place holder to be able to create the dio queues.
  */
-static void crystalhd_tx_desc_rel_call_back(void *context, void *data)
+void crystalhd_tx_desc_rel_call_back(void *context, void *data)
 {
 }
 
@@ -414,20 +196,18 @@ static void crystalhd_tx_desc_rel_call_back(void *context, void *data)
  * back to our free pool. The actual cleanup of the DMA
  * ring descriptors happen during dma ring release.
  */
-static void crystalhd_rx_pkt_rel_call_back(void *context, void *data)
+void crystalhd_rx_pkt_rel_call_back(void *context, void *data)
 {
 	struct crystalhd_hw *hw = (struct crystalhd_hw *)context;
 	struct crystalhd_rx_dma_pkt *pkt = (struct crystalhd_rx_dma_pkt *)data;
 
 	if (!pkt || !hw) {
-		BCMLOG_ERR("Invalid arg - %p %p\n", hw, pkt);
+		printk(KERN_ERR "%s: Invalid arg - %p %p\n", __func__, hw, pkt);
 		return;
 	}
 
 	if (pkt->dio_req)
 		crystalhd_unmap_dio(hw->adp, pkt->dio_req);
-	else
-		BCMLOG_ERR("Missing dio_req: 0x%x\n", pkt->pkt_tag);
 
 	crystalhd_hw_free_rx_pkt(hw, pkt);
 }
@@ -438,12 +218,11 @@ static void crystalhd_rx_pkt_rel_call_back(void *context, void *data)
 		q = NULL;			\
 	}
 
-static void crystalhd_hw_delete_ioqs(struct crystalhd_hw *hw)
+void crystalhd_hw_delete_ioqs(struct crystalhd_hw *hw)
 {
 	if (!hw)
 		return;
 
-	BCMLOG(BCMLOG_DBG, "Deleting IOQs\n");
 	crystalhd_hw_delete_ioq(hw->adp, hw->tx_actq);
 	crystalhd_hw_delete_ioq(hw->adp, hw->tx_freeq);
 	crystalhd_hw_delete_ioq(hw->adp, hw->rx_actq);
@@ -464,12 +243,12 @@ do {								\
  * TX - Active & Free
  * RX - Active, Ready and Free.
  */
-static enum BC_STATUS crystalhd_hw_create_ioqs(struct crystalhd_hw   *hw)
+enum BC_STATUS crystalhd_hw_create_ioqs(struct crystalhd_hw *hw)
 {
 	enum BC_STATUS   sts = BC_STS_SUCCESS;
 
 	if (!hw) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		printk(KERN_ERR "%s: Invalid Arg!!\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -493,64 +272,134 @@ hw_create_ioq_err:
 	return sts;
 }
 
+enum BC_STATUS crystalhd_hw_setup_dma_rings(struct crystalhd_hw *hw)
+{
+	struct device *dev;
+	unsigned int i;
+	void *mem;
+	size_t mem_len;
+	dma_addr_t phy_addr;
+	enum BC_STATUS sts = BC_STS_SUCCESS;
+	struct crystalhd_rx_dma_pkt *rpkt;
+
+	if (!hw || !hw->adp) {
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
+		return BC_STS_INV_ARG;
+	}
+
+	dev = &hw->adp->pdev->dev;
+
+	sts = crystalhd_hw_create_ioqs(hw);
+	if (sts != BC_STS_SUCCESS) {
+		dev_err(dev, "Failed to create IOQs..\n");
+		return sts;
+	}
+
+	mem_len = BC_LINK_MAX_SGLS * sizeof(struct dma_descriptor);
+
+	for (i = 0; i < BC_TX_LIST_CNT; i++) {
+		mem = bc_kern_dma_alloc(hw->adp, mem_len, &phy_addr);
+		if (mem) {
+			memset(mem, 0, mem_len);
+		} else {
+			dev_err(dev, "Insufficient Memory For TX\n");
+			crystalhd_hw_free_dma_rings(hw);
+			return BC_STS_INSUFF_RES;
+		}
+		/* rx_pkt_pool -- static memory allocation  */
+		hw->tx_pkt_pool[i].desc_mem.pdma_desc_start = mem;
+		hw->tx_pkt_pool[i].desc_mem.phy_addr = phy_addr;
+		hw->tx_pkt_pool[i].desc_mem.sz = BC_LINK_MAX_SGLS *
+						 sizeof(struct dma_descriptor);
+		hw->tx_pkt_pool[i].list_tag = 0;
+
+		/* Add TX dma requests to Free Queue..*/
+		sts = crystalhd_dioq_add(hw->tx_freeq,
+				       &hw->tx_pkt_pool[i], false, 0);
+		if (sts != BC_STS_SUCCESS) {
+			crystalhd_hw_free_dma_rings(hw);
+			return sts;
+		}
+	}
+
+	for (i = 0; i < BC_RX_LIST_CNT; i++) {
+		rpkt = kzalloc(sizeof(*rpkt), GFP_KERNEL);
+		if (!rpkt) {
+			dev_err(dev, "Insufficient Memory For RX\n");
+			crystalhd_hw_free_dma_rings(hw);
+			return BC_STS_INSUFF_RES;
+		}
+
+		mem = bc_kern_dma_alloc(hw->adp, mem_len, &phy_addr);
+		if (mem) {
+			memset(mem, 0, mem_len);
+		} else {
+			dev_err(dev, "Insufficient Memory For RX\n");
+			crystalhd_hw_free_dma_rings(hw);
+			return BC_STS_INSUFF_RES;
+		}
+		rpkt->desc_mem.pdma_desc_start = mem;
+		rpkt->desc_mem.phy_addr = phy_addr;
+		rpkt->desc_mem.sz  = BC_LINK_MAX_SGLS * sizeof(struct dma_descriptor);
+		rpkt->pkt_tag = hw->rx_pkt_tag_seed + i;
+		crystalhd_hw_free_rx_pkt(hw, rpkt);
+	}
+
+	return BC_STS_SUCCESS;
+}
 
-static bool crystalhd_code_in_full(struct crystalhd_adp *adp,
-		 uint32_t needed_sz, bool b_188_byte_pkts,  uint8_t flags)
+enum BC_STATUS crystalhd_hw_free_dma_rings(struct crystalhd_hw *hw)
 {
-	uint32_t base, end, writep, readp;
-	uint32_t cpbSize, cpbFullness, fifoSize;
-
-	if (flags & 0x02) { /* ASF Bit is set */
-		base   = bc_dec_reg_rd(adp, REG_Dec_TsAudCDB2Base);
-		end    = bc_dec_reg_rd(adp, REG_Dec_TsAudCDB2End);
-		writep = bc_dec_reg_rd(adp, REG_Dec_TsAudCDB2Wrptr);
-		readp  = bc_dec_reg_rd(adp, REG_Dec_TsAudCDB2Rdptr);
-	} else if (b_188_byte_pkts) { /*Encrypted 188 byte packets*/
-		base   = bc_dec_reg_rd(adp, REG_Dec_TsUser0Base);
-		end    = bc_dec_reg_rd(adp, REG_Dec_TsUser0End);
-		writep = bc_dec_reg_rd(adp, REG_Dec_TsUser0Wrptr);
-		readp  = bc_dec_reg_rd(adp, REG_Dec_TsUser0Rdptr);
-	} else {
-		base   = bc_dec_reg_rd(adp, REG_DecCA_RegCinBase);
-		end    = bc_dec_reg_rd(adp, REG_DecCA_RegCinEnd);
-		writep = bc_dec_reg_rd(adp, REG_DecCA_RegCinWrPtr);
-		readp  = bc_dec_reg_rd(adp, REG_DecCA_RegCinRdPtr);
+	unsigned int i;
+	struct crystalhd_rx_dma_pkt *rpkt = NULL;
+
+	if (!hw || !hw->adp) {
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
+		return BC_STS_INV_ARG;
 	}
 
-	cpbSize = end - base;
-	if (writep >= readp)
-		cpbFullness = writep - readp;
-	else
-		cpbFullness = (end - base) - (readp - writep);
+	/* Delete all IOQs.. */
+	crystalhd_hw_delete_ioqs(hw);
 
-	fifoSize = cpbSize - cpbFullness;
+	for (i = 0; i < BC_TX_LIST_CNT; i++) {
+		if (hw->tx_pkt_pool[i].desc_mem.pdma_desc_start) {
+			bc_kern_dma_free(hw->adp,
+				hw->tx_pkt_pool[i].desc_mem.sz,
+				hw->tx_pkt_pool[i].desc_mem.pdma_desc_start,
+				hw->tx_pkt_pool[i].desc_mem.phy_addr);
 
-	if (fifoSize < BC_INFIFO_THRESHOLD)
-		return true;
+			hw->tx_pkt_pool[i].desc_mem.pdma_desc_start = NULL;
+		}
+	}
 
-	if (needed_sz > (fifoSize - BC_INFIFO_THRESHOLD))
-		return true;
+	dev_dbg(&hw->adp->pdev->dev, "Releasing RX Pkt pool\n");
+	for (i = 0; i < BC_RX_LIST_CNT; i++) {
+		rpkt = crystalhd_hw_alloc_rx_pkt(hw);
+		if (!rpkt)
+			break;
+		bc_kern_dma_free(hw->adp, rpkt->desc_mem.sz,
+				 rpkt->desc_mem.pdma_desc_start,
+				 rpkt->desc_mem.phy_addr);
+		kfree(rpkt);
+	}
 
-	return false;
+	return BC_STS_SUCCESS;
 }
 
-static enum BC_STATUS crystalhd_hw_tx_req_complete(struct crystalhd_hw *hw,
-					 uint32_t list_id, enum BC_STATUS cs)
+enum BC_STATUS crystalhd_hw_tx_req_complete(struct crystalhd_hw *hw,
+											  uint32_t list_id, enum BC_STATUS cs)
 {
 	struct tx_dma_pkt *tx_req;
 
 	if (!hw || !list_id) {
-		BCMLOG_ERR("Invalid Arg..\n");
+		printk(KERN_ERR "%s: Invalid Arg!!\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
-	hw->pwr_lock--;
-
-	tx_req = (struct tx_dma_pkt *)crystalhd_dioq_find_and_fetch(
-					hw->tx_actq, list_id);
+	tx_req = (struct tx_dma_pkt *)crystalhd_dioq_find_and_fetch(hw->tx_actq, list_id);
 	if (!tx_req) {
 		if (cs != BC_STS_IO_USER_ABORT)
-			BCMLOG_ERR("Find and Fetch Did not find req\n");
+			dev_err(&hw->adp->pdev->dev, "Find/Fetch: no req!\n");
 		return BC_STS_NO_DATA;
 	}
 
@@ -560,8 +409,8 @@ static enum BC_STATUS crystalhd_hw_tx_req_complete(struct crystalhd_hw *hw,
 		tx_req->cb_event  = NULL;
 		tx_req->call_back = NULL;
 	} else {
-		BCMLOG(BCMLOG_DBG, "Missing Tx Callback - %X\n",
-		       tx_req->list_tag);
+		dev_dbg(&hw->adp->pdev->dev, "Missing Tx Callback - %X\n",
+		tx_req->list_tag);
 	}
 
 	/* Now put back the tx_list back in FreeQ */
@@ -570,146 +419,21 @@ static enum BC_STATUS crystalhd_hw_tx_req_complete(struct crystalhd_hw *hw,
 	return crystalhd_dioq_add(hw->tx_freeq, tx_req, false, 0);
 }
 
-static bool crystalhd_tx_list0_handler(struct crystalhd_hw *hw,
-					 uint32_t err_sts)
-{
-	uint32_t err_mask, tmp;
-	unsigned long flags = 0;
-
-	err_mask = MISC1_TX_DMA_ERROR_STATUS_TX_L0_DESC_TX_ABORT_ERRORS_MASK |
-		MISC1_TX_DMA_ERROR_STATUS_TX_L0_DMA_DATA_TX_ABORT_ERRORS_MASK |
-		MISC1_TX_DMA_ERROR_STATUS_TX_L0_FIFO_FULL_ERRORS_MASK;
-
-	if (!(err_sts & err_mask))
-		return false;
-
-	BCMLOG_ERR("Error on Tx-L0 %x\n", err_sts);
-
-	tmp = err_mask;
-
-	if (err_sts & MISC1_TX_DMA_ERROR_STATUS_TX_L0_FIFO_FULL_ERRORS_MASK)
-		tmp &= ~MISC1_TX_DMA_ERROR_STATUS_TX_L0_FIFO_FULL_ERRORS_MASK;
-
-	if (tmp) {
-		spin_lock_irqsave(&hw->lock, flags);
-		/* reset list index.*/
-		hw->tx_list_post_index = 0;
-		spin_unlock_irqrestore(&hw->lock, flags);
-	}
-
-	tmp = err_sts & err_mask;
-	crystalhd_reg_wr(hw->adp, MISC1_TX_DMA_ERROR_STATUS, tmp);
-
-	return true;
-}
-
-static bool crystalhd_tx_list1_handler(struct crystalhd_hw *hw,
-					 uint32_t err_sts)
-{
-	uint32_t err_mask, tmp;
-	unsigned long flags = 0;
-
-	err_mask = MISC1_TX_DMA_ERROR_STATUS_TX_L1_DESC_TX_ABORT_ERRORS_MASK |
-		MISC1_TX_DMA_ERROR_STATUS_TX_L1_DMA_DATA_TX_ABORT_ERRORS_MASK |
-		MISC1_TX_DMA_ERROR_STATUS_TX_L1_FIFO_FULL_ERRORS_MASK;
-
-	if (!(err_sts & err_mask))
-		return false;
-
-	BCMLOG_ERR("Error on Tx-L1 %x\n", err_sts);
-
-	tmp = err_mask;
-
-	if (err_sts & MISC1_TX_DMA_ERROR_STATUS_TX_L1_FIFO_FULL_ERRORS_MASK)
-		tmp &= ~MISC1_TX_DMA_ERROR_STATUS_TX_L1_FIFO_FULL_ERRORS_MASK;
-
-	if (tmp) {
-		spin_lock_irqsave(&hw->lock, flags);
-		/* reset list index.*/
-		hw->tx_list_post_index = 0;
-		spin_unlock_irqrestore(&hw->lock, flags);
-	}
-
-	tmp = err_sts & err_mask;
-	crystalhd_reg_wr(hw->adp, MISC1_TX_DMA_ERROR_STATUS, tmp);
-
-	return true;
-}
-
-static void crystalhd_tx_isr(struct crystalhd_hw *hw, uint32_t int_sts)
-{
-	uint32_t err_sts;
-
-	if (int_sts & INTR_INTR_STATUS_L0_TX_DMA_DONE_INTR_MASK)
-		crystalhd_hw_tx_req_complete(hw, hw->tx_ioq_tag_seed + 0,
-					   BC_STS_SUCCESS);
-
-	if (int_sts & INTR_INTR_STATUS_L1_TX_DMA_DONE_INTR_MASK)
-		crystalhd_hw_tx_req_complete(hw, hw->tx_ioq_tag_seed + 1,
-					   BC_STS_SUCCESS);
-
-	if (!(int_sts & (INTR_INTR_STATUS_L0_TX_DMA_ERR_INTR_MASK |
-			INTR_INTR_STATUS_L1_TX_DMA_ERR_INTR_MASK))) {
-			/* No error mask set.. */
-			return;
-	}
-
-	/* Handle Tx errors. */
-	err_sts = crystalhd_reg_rd(hw->adp, MISC1_TX_DMA_ERROR_STATUS);
-
-	if (crystalhd_tx_list0_handler(hw, err_sts))
-		crystalhd_hw_tx_req_complete(hw, hw->tx_ioq_tag_seed + 0,
-					   BC_STS_ERROR);
-
-	if (crystalhd_tx_list1_handler(hw, err_sts))
-		crystalhd_hw_tx_req_complete(hw, hw->tx_ioq_tag_seed + 1,
-					   BC_STS_ERROR);
-
-	hw->stats.tx_errors++;
-}
-
-static void crystalhd_hw_dump_desc(struct dma_descriptor *p_dma_desc,
-				 uint32_t ul_desc_index, uint32_t cnt)
-{
-	uint32_t ix, ll = 0;
-
-	if (!p_dma_desc || !cnt)
-		return;
-
-	/* FIXME: jarod: perhaps a modparam desc_debug to enable this,
-	 rather than setting ll (log level, I presume) to non-zero? */
-	if (!ll)
-		return;
-
-	for (ix = ul_desc_index; ix < (ul_desc_index + cnt); ix++) {
-		BCMLOG(ll,
-		 "%s[%d] Buff[%x:%x] Next:[%x:%x] XferSz:%x Intr:%x,Last:%x\n",
-		 ((p_dma_desc[ul_desc_index].dma_dir) ? "TDesc" : "RDesc"),
-		       ul_desc_index,
-		       p_dma_desc[ul_desc_index].buff_addr_high,
-		       p_dma_desc[ul_desc_index].buff_addr_low,
-		       p_dma_desc[ul_desc_index].next_desc_addr_high,
-		       p_dma_desc[ul_desc_index].next_desc_addr_low,
-		       p_dma_desc[ul_desc_index].xfer_size,
-		       p_dma_desc[ul_desc_index].intr_enable,
-		       p_dma_desc[ul_desc_index].last_rec_indicator);
-	}
-
-}
-
-static enum BC_STATUS crystalhd_hw_fill_desc(struct crystalhd_dio_req *ioreq,
-				      struct dma_descriptor *desc,
-				      dma_addr_t desc_paddr_base,
-				      uint32_t sg_cnt, uint32_t sg_st_ix,
-				      uint32_t sg_st_off, uint32_t xfr_sz)
+enum BC_STATUS crystalhd_hw_fill_desc(struct crystalhd_dio_req *ioreq,
+										struct dma_descriptor *desc,
+										dma_addr_t desc_paddr_base,
+										uint32_t sg_cnt, uint32_t sg_st_ix,
+										uint32_t sg_st_off, uint32_t xfr_sz,
+										struct device *dev, uint32_t destDRAMaddr)
 {
 	uint32_t count = 0, ix = 0, sg_ix = 0, len = 0, last_desc_ix = 0;
 	dma_addr_t desc_phy_addr = desc_paddr_base;
-	union addr_64 addr_temp;
+	addr_64 addr_temp;
+	uint32_t curDRAMaddr = destDRAMaddr;
 
 	if (!ioreq || !desc || !desc_paddr_base || !xfr_sz ||
-	    (!sg_cnt && !ioreq->uinfo.dir_tx)) {
-		BCMLOG_ERR("Invalid Args\n");
+		(!sg_cnt && !ioreq->uinfo.dir_tx)) {
+		dev_err(dev, "%s: Invalid Args\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -721,8 +445,8 @@ static enum BC_STATUS crystalhd_hw_fill_desc(struct crystalhd_dio_req *ioreq,
 		/* Get SGLE length */
 		len = crystalhd_get_sgle_len(ioreq, sg_ix);
 		if (len % 4) {
-			BCMLOG_ERR(" len in sg %d %d %d\n", len, sg_ix,
-				 sg_cnt);
+			dev_err(dev, "unsupported len in sg %d %d %d\n",
+			len, sg_ix, sg_cnt);
 			return BC_STS_NOT_IMPL;
 		}
 		/* Setup DMA desc with Phy addr & Length at current index. */
@@ -734,11 +458,10 @@ static enum BC_STATUS crystalhd_hw_fill_desc(struct crystalhd_dio_req *ioreq,
 		memset(&desc[ix], 0, sizeof(desc[ix]));
 		desc[ix].buff_addr_low  = addr_temp.low_part;
 		desc[ix].buff_addr_high = addr_temp.high_part;
-		desc[ix].dma_dir        = ioreq->uinfo.dir_tx;
+		desc[ix].dma_dir        = ioreq->uinfo.dir_tx; /* RX dma_dir = 0, TX dma_dir = 1 */
 
 		/* Chain DMA descriptor.  */
-		addr_temp.full_addr = desc_phy_addr +
-					 sizeof(struct dma_descriptor);
+		addr_temp.full_addr = desc_phy_addr + sizeof(struct dma_descriptor);
 		desc[ix].next_desc_addr_low = addr_temp.low_part;
 		desc[ix].next_desc_addr_high = addr_temp.high_part;
 
@@ -747,17 +470,22 @@ static enum BC_STATUS crystalhd_hw_fill_desc(struct crystalhd_dio_req *ioreq,
 
 		/* Debug.. */
 		if ((!len) || (len > crystalhd_get_sgle_len(ioreq, sg_ix))) {
-			BCMLOG_ERR(
-			 "inv-len(%x) Ix(%d) count:%x xfr_sz:%x sg_cnt:%d\n",
-			 len, ix, count, xfr_sz, sg_cnt);
+			dev_err(dev, "inv-len(%x) Ix(%d) count:%x xfr_sz:%x "
+			"sg_cnt:%d\n", len, ix, count, xfr_sz, sg_cnt);
 			return BC_STS_ERROR;
 		}
 		/* Length expects Multiple of 4 */
 		desc[ix].xfer_size = (len / 4);
 
-		crystalhd_hw_dump_desc(desc, ix, 1);
-
 		count += len;
+		/* If TX fill in the destination DRAM address if needed */
+		if(ioreq->uinfo.dir_tx) {
+			desc[ix].sdram_buff_addr = curDRAMaddr;
+			curDRAMaddr = destDRAMaddr + count;
+		}
+		else
+			desc[ix].sdram_buff_addr = 0;
+
 		desc_phy_addr += sizeof(struct dma_descriptor);
 	}
 
@@ -772,6 +500,13 @@ static enum BC_STATUS crystalhd_hw_fill_desc(struct crystalhd_dio_req *ioreq,
 		desc[ix].xfer_size	= 1;
 		desc[ix].fill_bytes	= 4 - ioreq->fb_size;
 		count += ioreq->fb_size;
+		/* If TX fill in the destination DRAM address if needed */
+		if(ioreq->uinfo.dir_tx) {
+			desc[ix].sdram_buff_addr = curDRAMaddr;
+			curDRAMaddr = destDRAMaddr + count;
+		}
+		else
+			desc[ix].sdram_buff_addr = 0;
 		last_desc_ix++;
 	}
 
@@ -781,20 +516,19 @@ static enum BC_STATUS crystalhd_hw_fill_desc(struct crystalhd_dio_req *ioreq,
 	desc[last_desc_ix].next_desc_addr_high = 0;
 	desc[last_desc_ix].intr_enable = 1;
 
-	crystalhd_hw_dump_desc(desc, last_desc_ix, 1);
-
 	if (count != xfr_sz) {
-		BCMLOG_ERR("internal error sz curr:%x exp:%x\n", count, xfr_sz);
+		dev_err(dev, "interal error sz curr:%x exp:%x\n",
+		count, xfr_sz);
 		return BC_STS_ERROR;
 	}
 
 	return BC_STS_SUCCESS;
 }
 
-static enum BC_STATUS crystalhd_xlat_sgl_to_dma_desc(
-					      struct crystalhd_dio_req *ioreq,
-					      struct dma_desc_mem *pdesc_mem,
-					      uint32_t *uv_desc_index)
+enum BC_STATUS crystalhd_xlat_sgl_to_dma_desc(struct crystalhd_dio_req *ioreq,
+												struct dma_desc_mem * pdesc_mem,
+												uint32_t *uv_desc_index,
+												struct device *dev, uint32_t destDRAMaddr)
 {
 	struct dma_descriptor *desc = NULL;
 	dma_addr_t desc_paddr_base = 0;
@@ -804,18 +538,18 @@ static enum BC_STATUS crystalhd_xlat_sgl_to_dma_desc(
 
 	/* Check params.. */
 	if (!ioreq || !pdesc_mem || !uv_desc_index) {
-		BCMLOG_ERR("Invalid Args\n");
+		dev_err(dev, "%s: Invalid Args\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	if (!pdesc_mem->sz || !pdesc_mem->pdma_desc_start ||
-	    !ioreq->sg || (!ioreq->sg_cnt && !ioreq->uinfo.dir_tx)) {
-		BCMLOG_ERR("Invalid Args\n");
+		!ioreq->sg || (!ioreq->sg_cnt && !ioreq->uinfo.dir_tx)) {
+		dev_err(dev, "%s: Invalid Args\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	if ((ioreq->uinfo.dir_tx) && (ioreq->uinfo.uv_offset)) {
-		BCMLOG_ERR("UV offset for TX??\n");
+		dev_err(dev, "%s: UV offset for TX??\n", __func__);
 		return BC_STS_INV_ARG;
 
 	}
@@ -832,7 +566,7 @@ static enum BC_STATUS crystalhd_xlat_sgl_to_dma_desc(
 	}
 
 	sts = crystalhd_hw_fill_desc(ioreq, desc, desc_paddr_base, sg_cnt,
-				   sg_st_ix, sg_st_off, xfr_sz);
+									sg_st_ix, sg_st_off, xfr_sz, dev, destDRAMaddr);
 
 	if ((sts != BC_STS_SUCCESS) || !ioreq->uinfo.uv_offset)
 		return sts;
@@ -840,7 +574,7 @@ static enum BC_STATUS crystalhd_xlat_sgl_to_dma_desc(
 	/* Prepare for UV mapping.. */
 	desc = &pdesc_mem->pdma_desc_start[sg_cnt];
 	desc_paddr_base = pdesc_mem->phy_addr +
-			  (sg_cnt * sizeof(struct dma_descriptor));
+	(sg_cnt * sizeof(struct dma_descriptor));
 
 	/* Done with desc addr.. now update sg stuff.*/
 	sg_cnt    = ioreq->sg_cnt - ioreq->uinfo.uv_sg_ix;
@@ -849,7 +583,7 @@ static enum BC_STATUS crystalhd_xlat_sgl_to_dma_desc(
 	sg_st_off = ioreq->uinfo.uv_sg_off;
 
 	sts = crystalhd_hw_fill_desc(ioreq, desc, desc_paddr_base, sg_cnt,
-				   sg_st_ix, sg_st_off, xfr_sz);
+								sg_st_ix, sg_st_off, xfr_sz, dev, destDRAMaddr);
 	if (sts != BC_STS_SUCCESS)
 		return sts;
 
@@ -858,1239 +592,149 @@ static enum BC_STATUS crystalhd_xlat_sgl_to_dma_desc(
 	return sts;
 }
 
-static void crystalhd_start_tx_dma_engine(struct crystalhd_hw *hw)
+enum BC_STATUS crystalhd_rx_pkt_done(struct crystalhd_hw *hw,
+									   uint32_t list_index,
+									   enum BC_STATUS comp_sts)
 {
-	uint32_t dma_cntrl;
+	struct crystalhd_rx_dma_pkt *rx_pkt = NULL;
+	uint32_t y_dw_dnsz, uv_dw_dnsz;
+	enum BC_STATUS sts = BC_STS_SUCCESS;
+	uint64_t currTick;
 
-	dma_cntrl = crystalhd_reg_rd(hw->adp, MISC1_TX_SW_DESC_LIST_CTRL_STS);
-	if (!(dma_cntrl & DMA_START_BIT)) {
-		dma_cntrl |= DMA_START_BIT;
-		crystalhd_reg_wr(hw->adp, MISC1_TX_SW_DESC_LIST_CTRL_STS,
-			       dma_cntrl);
+	uint32_t totalTick_Hi;
+	uint32_t TickSpentInPD_Hi;
+	uint64_t temp_64;
+	int32_t totalTick_Hi_f;
+	int32_t TickSpentInPD_Hi_f;
+
+	if (!hw || list_index >= DMA_ENGINE_CNT) {
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
+		return BC_STS_INV_ARG;
 	}
 
-	return;
-}
-
-/* _CHECK_THIS_
- *
- * Verify if the Stop generates a completion interrupt or not.
- * if it does not generate an interrupt, then add polling here.
- */
-static enum BC_STATUS crystalhd_stop_tx_dma_engine(struct crystalhd_hw *hw)
-{
-	uint32_t dma_cntrl, cnt = 30;
-	uint32_t l1 = 1, l2 = 1;
-	unsigned long flags = 0;
-
-	dma_cntrl = crystalhd_reg_rd(hw->adp, MISC1_TX_SW_DESC_LIST_CTRL_STS);
-
-	BCMLOG(BCMLOG_DBG, "Stopping TX DMA Engine..\n");
-
-	if (!(dma_cntrl & DMA_START_BIT)) {
-		BCMLOG(BCMLOG_DBG, "Already Stopped\n");
-		return BC_STS_SUCCESS;
-	}
-
-	crystalhd_disable_interrupts(hw->adp);
-
-	/* Issue stop to HW */
-	/* This bit when set gave problems. Please check*/
-	dma_cntrl &= ~DMA_START_BIT;
-	crystalhd_reg_wr(hw->adp, MISC1_TX_SW_DESC_LIST_CTRL_STS, dma_cntrl);
-
-	BCMLOG(BCMLOG_DBG, "Cleared the DMA Start bit\n");
-
-	/* Poll for 3seconds (30 * 100ms) on both the lists..*/
-	while ((l1 || l2) && cnt) {
-
-		if (l1) {
-			l1 = crystalhd_reg_rd(hw->adp,
-				 MISC1_TX_FIRST_DESC_L_ADDR_LIST0);
-			l1 &= DMA_START_BIT;
-		}
-
-		if (l2) {
-			l2 = crystalhd_reg_rd(hw->adp,
-				 MISC1_TX_FIRST_DESC_L_ADDR_LIST1);
-			l2 &= DMA_START_BIT;
-		}
-
-		msleep_interruptible(100);
-
-		cnt--;
-	}
-
-	if (!cnt) {
-		BCMLOG_ERR("Failed to stop TX DMA.. l1 %d, l2 %d\n", l1, l2);
-		crystalhd_enable_interrupts(hw->adp);
-		return BC_STS_ERROR;
-	}
-
-	spin_lock_irqsave(&hw->lock, flags);
-	hw->tx_list_post_index = 0;
-	spin_unlock_irqrestore(&hw->lock, flags);
-	BCMLOG(BCMLOG_DBG, "stopped TX DMA..\n");
-	crystalhd_enable_interrupts(hw->adp);
-
-	return BC_STS_SUCCESS;
-}
-
-static uint32_t crystalhd_get_pib_avail_cnt(struct crystalhd_hw *hw)
-{
-	/*
-	* Position of the PIB Entries can be found at
-	* 0th and the 1st location of the Circular list.
-	*/
-	uint32_t Q_addr;
-	uint32_t pib_cnt, r_offset, w_offset;
-
-	Q_addr = hw->pib_del_Q_addr;
-
-	/* Get the Read Pointer */
-	crystalhd_mem_rd(hw->adp, Q_addr, 1, &r_offset);
-
-	/* Get the Write Pointer */
-	crystalhd_mem_rd(hw->adp, Q_addr + sizeof(uint32_t), 1, &w_offset);
-
-	if (r_offset == w_offset)
-		return 0;	/* Queue is empty */
-
-	if (w_offset > r_offset)
-		pib_cnt = w_offset - r_offset;
-	else
-		pib_cnt = (w_offset + MAX_PIB_Q_DEPTH) -
-			  (r_offset + MIN_PIB_Q_DEPTH);
-
-	if (pib_cnt > MAX_PIB_Q_DEPTH) {
-		BCMLOG_ERR("Invalid PIB Count (%u)\n", pib_cnt);
-		return 0;
-	}
-
-	return pib_cnt;
-}
-
-static uint32_t crystalhd_get_addr_from_pib_Q(struct crystalhd_hw *hw)
-{
-	uint32_t Q_addr;
-	uint32_t addr_entry, r_offset, w_offset;
-
-	Q_addr = hw->pib_del_Q_addr;
-
-	/* Get the Read Pointer 0Th Location is Read Pointer */
-	crystalhd_mem_rd(hw->adp, Q_addr, 1, &r_offset);
-
-	/* Get the Write Pointer 1st Location is Write pointer */
-	crystalhd_mem_rd(hw->adp, Q_addr + sizeof(uint32_t), 1, &w_offset);
-
-	/* Queue is empty */
-	if (r_offset == w_offset)
-		return 0;
-
-	if ((r_offset < MIN_PIB_Q_DEPTH) || (r_offset >= MAX_PIB_Q_DEPTH))
-		return 0;
-
-	/* Get the Actual Address of the PIB */
-	crystalhd_mem_rd(hw->adp, Q_addr + (r_offset * sizeof(uint32_t)),
-		       1, &addr_entry);
-
-	/* Increment the Read Pointer */
-	r_offset++;
-
-	if (MAX_PIB_Q_DEPTH == r_offset)
-		r_offset = MIN_PIB_Q_DEPTH;
-
-	/* Write back the read pointer to It's Location */
-	crystalhd_mem_wr(hw->adp, Q_addr, 1, &r_offset);
-
-	return addr_entry;
-}
-
-static bool crystalhd_rel_addr_to_pib_Q(struct crystalhd_hw *hw,
-					 uint32_t addr_to_rel)
-{
-	uint32_t Q_addr;
-	uint32_t r_offset, w_offset, n_offset;
-
-	Q_addr = hw->pib_rel_Q_addr;
-
-	/* Get the Read Pointer */
-	crystalhd_mem_rd(hw->adp, Q_addr, 1, &r_offset);
-
-	/* Get the Write Pointer */
-	crystalhd_mem_rd(hw->adp, Q_addr + sizeof(uint32_t), 1, &w_offset);
-
-	if ((r_offset < MIN_PIB_Q_DEPTH) ||
-	    (r_offset >= MAX_PIB_Q_DEPTH))
-		return false;
-
-	n_offset = w_offset + 1;
-
-	if (MAX_PIB_Q_DEPTH == n_offset)
-		n_offset = MIN_PIB_Q_DEPTH;
-
-	if (r_offset == n_offset)
-		return false; /* should never happen */
-
-	/* Write the DRAM ADDR to the Queue at Next Offset */
-	crystalhd_mem_wr(hw->adp, Q_addr + (w_offset * sizeof(uint32_t)),
-		       1, &addr_to_rel);
-
-	/* Put the New value of the write pointer in Queue */
-	crystalhd_mem_wr(hw->adp, Q_addr + sizeof(uint32_t), 1, &n_offset);
-
-	return true;
-}
-
-static void cpy_pib_to_app(struct c011_pib *src_pib,
-					 struct BC_PIC_INFO_BLOCK *dst_pib)
-{
-	if (!src_pib || !dst_pib) {
-		BCMLOG_ERR("Invalid Arguments\n");
-		return;
-	}
-
-	dst_pib->timeStamp           = 0;
-	dst_pib->picture_number      = src_pib->ppb.picture_number;
-	dst_pib->width               = src_pib->ppb.width;
-	dst_pib->height              = src_pib->ppb.height;
-	dst_pib->chroma_format       = src_pib->ppb.chroma_format;
-	dst_pib->pulldown            = src_pib->ppb.pulldown;
-	dst_pib->flags               = src_pib->ppb.flags;
-	dst_pib->sess_num            = src_pib->ptsStcOffset;
-	dst_pib->aspect_ratio        = src_pib->ppb.aspect_ratio;
-	dst_pib->colour_primaries     = src_pib->ppb.colour_primaries;
-	dst_pib->picture_meta_payload = src_pib->ppb.picture_meta_payload;
-	dst_pib->frame_rate		= src_pib->resolution;
-	return;
-}
-
-static void crystalhd_hw_proc_pib(struct crystalhd_hw *hw)
-{
-	unsigned int cnt;
-	struct c011_pib src_pib;
-	uint32_t pib_addr, pib_cnt;
-	struct BC_PIC_INFO_BLOCK *AppPib;
-	struct crystalhd_rx_dma_pkt *rx_pkt = NULL;
-
-	pib_cnt = crystalhd_get_pib_avail_cnt(hw);
-
-	if (!pib_cnt)
-		return;
-
-	for (cnt = 0; cnt < pib_cnt; cnt++) {
-
-		pib_addr = crystalhd_get_addr_from_pib_Q(hw);
-		crystalhd_mem_rd(hw->adp, pib_addr, sizeof(struct c011_pib) / 4,
-			       (uint32_t *)&src_pib);
-
-		if (src_pib.bFormatChange) {
-			rx_pkt = (struct crystalhd_rx_dma_pkt *)
-					crystalhd_dioq_fetch(hw->rx_freeq);
-			if (!rx_pkt)
-				return;
-			rx_pkt->flags = 0;
-			rx_pkt->flags |= COMP_FLAG_PIB_VALID |
-					 COMP_FLAG_FMT_CHANGE;
-			AppPib = &rx_pkt->pib;
-			cpy_pib_to_app(&src_pib, AppPib);
-
-			BCMLOG(BCMLOG_DBG,
-			       "App PIB:%x %x %x %x %x %x %x %x %x %x\n",
-			       rx_pkt->pib.picture_number,
-			       rx_pkt->pib.aspect_ratio,
-			       rx_pkt->pib.chroma_format,
-			       rx_pkt->pib.colour_primaries,
-			       rx_pkt->pib.frame_rate,
-			       rx_pkt->pib.height,
-			       rx_pkt->pib.height,
-			       rx_pkt->pib.n_drop,
-			       rx_pkt->pib.pulldown,
-			       rx_pkt->pib.ycom);
-
-			crystalhd_dioq_add(hw->rx_rdyq, (void *)rx_pkt, true,
-					 rx_pkt->pkt_tag);
-
-		}
-
-		crystalhd_rel_addr_to_pib_Q(hw, pib_addr);
-	}
-}
-
-static void crystalhd_start_rx_dma_engine(struct crystalhd_hw *hw)
-{
-	uint32_t        dma_cntrl;
-
-	dma_cntrl = crystalhd_reg_rd(hw->adp,
-			 MISC1_Y_RX_SW_DESC_LIST_CTRL_STS);
-	if (!(dma_cntrl & DMA_START_BIT)) {
-		dma_cntrl |= DMA_START_BIT;
-		crystalhd_reg_wr(hw->adp,
-			 MISC1_Y_RX_SW_DESC_LIST_CTRL_STS, dma_cntrl);
-	}
-
-	dma_cntrl = crystalhd_reg_rd(hw->adp,
-			 MISC1_UV_RX_SW_DESC_LIST_CTRL_STS);
-	if (!(dma_cntrl & DMA_START_BIT)) {
-		dma_cntrl |= DMA_START_BIT;
-		crystalhd_reg_wr(hw->adp,
-			 MISC1_UV_RX_SW_DESC_LIST_CTRL_STS, dma_cntrl);
-	}
-
-	return;
-}
-
-static void crystalhd_stop_rx_dma_engine(struct crystalhd_hw *hw)
-{
-	uint32_t dma_cntrl = 0, count = 30;
-	uint32_t l0y = 1, l0uv = 1, l1y = 1, l1uv = 1;
-
-	dma_cntrl = crystalhd_reg_rd(hw->adp,
-			 MISC1_Y_RX_SW_DESC_LIST_CTRL_STS);
-	if ((dma_cntrl & DMA_START_BIT)) {
-		dma_cntrl &= ~DMA_START_BIT;
-		crystalhd_reg_wr(hw->adp,
-			 MISC1_Y_RX_SW_DESC_LIST_CTRL_STS, dma_cntrl);
-	}
-
-	dma_cntrl = crystalhd_reg_rd(hw->adp,
-			 MISC1_UV_RX_SW_DESC_LIST_CTRL_STS);
-	if ((dma_cntrl & DMA_START_BIT)) {
-		dma_cntrl &= ~DMA_START_BIT;
-		crystalhd_reg_wr(hw->adp,
-			 MISC1_UV_RX_SW_DESC_LIST_CTRL_STS, dma_cntrl);
-	}
-
-	/* Poll for 3seconds (30 * 100ms) on both the lists..*/
-	while ((l0y || l0uv || l1y || l1uv) && count) {
-
-		if (l0y) {
-			l0y = crystalhd_reg_rd(hw->adp,
-				 MISC1_Y_RX_FIRST_DESC_L_ADDR_LIST0);
-			l0y &= DMA_START_BIT;
-			if (!l0y)
-				hw->rx_list_sts[0] &= ~rx_waiting_y_intr;
-		}
-
-		if (l1y) {
-			l1y = crystalhd_reg_rd(hw->adp,
-				 MISC1_Y_RX_FIRST_DESC_L_ADDR_LIST1);
-			l1y &= DMA_START_BIT;
-			if (!l1y)
-				hw->rx_list_sts[1] &= ~rx_waiting_y_intr;
-		}
-
-		if (l0uv) {
-			l0uv = crystalhd_reg_rd(hw->adp,
-				 MISC1_UV_RX_FIRST_DESC_L_ADDR_LIST0);
-			l0uv &= DMA_START_BIT;
-			if (!l0uv)
-				hw->rx_list_sts[0] &= ~rx_waiting_uv_intr;
-		}
-
-		if (l1uv) {
-			l1uv = crystalhd_reg_rd(hw->adp,
-				 MISC1_UV_RX_FIRST_DESC_L_ADDR_LIST1);
-			l1uv &= DMA_START_BIT;
-			if (!l1uv)
-				hw->rx_list_sts[1] &= ~rx_waiting_uv_intr;
-		}
-		msleep_interruptible(100);
-		count--;
-	}
-
-	hw->rx_list_post_index = 0;
-
-	BCMLOG(BCMLOG_SSTEP, "Capture Stop: %d List0:Sts:%x List1:Sts:%x\n",
-	       count, hw->rx_list_sts[0], hw->rx_list_sts[1]);
-}
-
-static enum BC_STATUS crystalhd_hw_prog_rxdma(struct crystalhd_hw *hw,
-					 struct crystalhd_rx_dma_pkt *rx_pkt)
-{
-	uint32_t y_low_addr_reg, y_high_addr_reg;
-	uint32_t uv_low_addr_reg, uv_high_addr_reg;
-	union addr_64 desc_addr;
-	unsigned long flags;
-
-	if (!hw || !rx_pkt) {
-		BCMLOG_ERR("Invalid Arguments\n");
-		return BC_STS_INV_ARG;
-	}
-
-	if (hw->rx_list_post_index >= DMA_ENGINE_CNT) {
-		BCMLOG_ERR("List Out Of bounds %x\n", hw->rx_list_post_index);
-		return BC_STS_INV_ARG;
-	}
-
-	spin_lock_irqsave(&hw->rx_lock, flags);
-	/* FIXME: jarod: sts_free is an enum for 0,
-	 in crystalhd_hw.h... yuk... */
-	if (sts_free != hw->rx_list_sts[hw->rx_list_post_index]) {
-		spin_unlock_irqrestore(&hw->rx_lock, flags);
-		return BC_STS_BUSY;
-	}
-
-	if (!hw->rx_list_post_index) {
-		y_low_addr_reg   = MISC1_Y_RX_FIRST_DESC_L_ADDR_LIST0;
-		y_high_addr_reg  = MISC1_Y_RX_FIRST_DESC_U_ADDR_LIST0;
-		uv_low_addr_reg  = MISC1_UV_RX_FIRST_DESC_L_ADDR_LIST0;
-		uv_high_addr_reg = MISC1_UV_RX_FIRST_DESC_U_ADDR_LIST0;
-	} else {
-		y_low_addr_reg   = MISC1_Y_RX_FIRST_DESC_L_ADDR_LIST1;
-		y_high_addr_reg  = MISC1_Y_RX_FIRST_DESC_U_ADDR_LIST1;
-		uv_low_addr_reg  = MISC1_UV_RX_FIRST_DESC_L_ADDR_LIST1;
-		uv_high_addr_reg = MISC1_UV_RX_FIRST_DESC_U_ADDR_LIST1;
-	}
-	rx_pkt->pkt_tag = hw->rx_pkt_tag_seed + hw->rx_list_post_index;
-	hw->rx_list_sts[hw->rx_list_post_index] |= rx_waiting_y_intr;
-	if (rx_pkt->uv_phy_addr)
-		hw->rx_list_sts[hw->rx_list_post_index] |= rx_waiting_uv_intr;
-	hw->rx_list_post_index = (hw->rx_list_post_index + 1) % DMA_ENGINE_CNT;
-	spin_unlock_irqrestore(&hw->rx_lock, flags);
-
-	crystalhd_dioq_add(hw->rx_actq, (void *)rx_pkt, false,
-			 rx_pkt->pkt_tag);
-
-	crystalhd_start_rx_dma_engine(hw);
-	/* Program the Y descriptor */
-	desc_addr.full_addr = rx_pkt->desc_mem.phy_addr;
-	crystalhd_reg_wr(hw->adp, y_high_addr_reg, desc_addr.high_part);
-	crystalhd_reg_wr(hw->adp, y_low_addr_reg, desc_addr.low_part | 0x01);
-
-	if (rx_pkt->uv_phy_addr) {
-		/* Program the UV descriptor */
-		desc_addr.full_addr = rx_pkt->uv_phy_addr;
-		crystalhd_reg_wr(hw->adp, uv_high_addr_reg,
-			 desc_addr.high_part);
-		crystalhd_reg_wr(hw->adp, uv_low_addr_reg,
-			 desc_addr.low_part | 0x01);
-	}
-
-	return BC_STS_SUCCESS;
-}
-
-static enum BC_STATUS crystalhd_hw_post_cap_buff(struct crystalhd_hw *hw,
-					  struct crystalhd_rx_dma_pkt *rx_pkt)
-{
-	enum BC_STATUS sts = crystalhd_hw_prog_rxdma(hw, rx_pkt);
-
-	if (sts == BC_STS_BUSY)
-		crystalhd_dioq_add(hw->rx_freeq, (void *)rx_pkt,
-				 false, rx_pkt->pkt_tag);
-
-	return sts;
-}
-
-static void crystalhd_get_dnsz(struct crystalhd_hw *hw, uint32_t list_index,
-			     uint32_t *y_dw_dnsz, uint32_t *uv_dw_dnsz)
-{
-	uint32_t y_dn_sz_reg, uv_dn_sz_reg;
-
-	if (!list_index) {
-		y_dn_sz_reg  = MISC1_Y_RX_LIST0_CUR_BYTE_CNT;
-		uv_dn_sz_reg = MISC1_UV_RX_LIST0_CUR_BYTE_CNT;
-	} else {
-		y_dn_sz_reg  = MISC1_Y_RX_LIST1_CUR_BYTE_CNT;
-		uv_dn_sz_reg = MISC1_UV_RX_LIST1_CUR_BYTE_CNT;
-	}
-
-	*y_dw_dnsz  = crystalhd_reg_rd(hw->adp, y_dn_sz_reg);
-	*uv_dw_dnsz = crystalhd_reg_rd(hw->adp, uv_dn_sz_reg);
-}
-
-/*
- * This function should be called only after making sure that the two DMA
- * lists are free. This function does not check if DMA's are active, before
- * turning off the DMA.
- */
-static void crystalhd_hw_finalize_pause(struct crystalhd_hw *hw)
-{
-	uint32_t dma_cntrl, aspm;
-
-	hw->stop_pending = 0;
-
-	dma_cntrl = crystalhd_reg_rd(hw->adp,
-			 MISC1_Y_RX_SW_DESC_LIST_CTRL_STS);
-	if (dma_cntrl & DMA_START_BIT) {
-		dma_cntrl &= ~DMA_START_BIT;
-		crystalhd_reg_wr(hw->adp,
-			 MISC1_Y_RX_SW_DESC_LIST_CTRL_STS, dma_cntrl);
-	}
-
-	dma_cntrl = crystalhd_reg_rd(hw->adp,
-			 MISC1_UV_RX_SW_DESC_LIST_CTRL_STS);
-	if (dma_cntrl & DMA_START_BIT) {
-		dma_cntrl &= ~DMA_START_BIT;
-		crystalhd_reg_wr(hw->adp,
-			 MISC1_UV_RX_SW_DESC_LIST_CTRL_STS, dma_cntrl);
-	}
-	hw->rx_list_post_index = 0;
-
-	aspm = crystalhd_reg_rd(hw->adp, PCIE_DLL_DATA_LINK_CONTROL);
-	aspm |= ASPM_L1_ENABLE;
-	/* NAREN BCMLOG(BCMLOG_INFO, "aspm on\n"); */
-	crystalhd_reg_wr(hw->adp, PCIE_DLL_DATA_LINK_CONTROL, aspm);
-}
-
-static enum BC_STATUS crystalhd_rx_pkt_done(struct crystalhd_hw *hw,
-			 uint32_t list_index, enum BC_STATUS comp_sts)
-{
-	struct crystalhd_rx_dma_pkt *rx_pkt = NULL;
-	uint32_t y_dw_dnsz, uv_dw_dnsz;
-	enum BC_STATUS sts = BC_STS_SUCCESS;
-
-	if (!hw || list_index >= DMA_ENGINE_CNT) {
-		BCMLOG_ERR("Invalid Arguments\n");
-		return BC_STS_INV_ARG;
-	}
-
-	rx_pkt = crystalhd_dioq_find_and_fetch(hw->rx_actq,
-					     hw->rx_pkt_tag_seed + list_index);
-	if (!rx_pkt) {
-		BCMLOG_ERR(
-		"Act-Q:PostIx:%x L0Sts:%x L1Sts:%x current L:%x tag:%x comp:%x\n",
-			   hw->rx_list_post_index, hw->rx_list_sts[0],
-			   hw->rx_list_sts[1], list_index,
-			   hw->rx_pkt_tag_seed + list_index, comp_sts);
-		return BC_STS_INV_ARG;
-	}
-
-	if (comp_sts == BC_STS_SUCCESS) {
-		crystalhd_get_dnsz(hw, list_index, &y_dw_dnsz, &uv_dw_dnsz);
-		rx_pkt->dio_req->uinfo.y_done_sz = y_dw_dnsz;
-		rx_pkt->flags = COMP_FLAG_DATA_VALID;
-		if (rx_pkt->uv_phy_addr)
-			rx_pkt->dio_req->uinfo.uv_done_sz = uv_dw_dnsz;
-		crystalhd_dioq_add(hw->rx_rdyq, rx_pkt, true,
-				hw->rx_pkt_tag_seed + list_index);
-		return sts;
-	}
-
-	/* Check if we can post this DIO again. */
-	return crystalhd_hw_post_cap_buff(hw, rx_pkt);
-}
-
-static bool crystalhd_rx_list0_handler(struct crystalhd_hw *hw,
-		 uint32_t int_sts, uint32_t y_err_sts, uint32_t uv_err_sts)
-{
-	uint32_t tmp;
-	enum list_sts tmp_lsts;
-
-	if (!(y_err_sts & GET_Y0_ERR_MSK) && !(uv_err_sts & GET_UV0_ERR_MSK))
-		return false;
-
-	tmp_lsts = hw->rx_list_sts[0];
-
-	/* Y0 - DMA */
-	tmp = y_err_sts & GET_Y0_ERR_MSK;
-	if (int_sts & INTR_INTR_STATUS_L0_Y_RX_DMA_DONE_INTR_MASK)
-		hw->rx_list_sts[0] &= ~rx_waiting_y_intr;
-
-	if (y_err_sts & MISC1_Y_RX_ERROR_STATUS_RX_L0_UNDERRUN_ERROR_MASK) {
-		hw->rx_list_sts[0] &= ~rx_waiting_y_intr;
-		tmp &= ~MISC1_Y_RX_ERROR_STATUS_RX_L0_UNDERRUN_ERROR_MASK;
-	}
-
-	if (y_err_sts & MISC1_Y_RX_ERROR_STATUS_RX_L0_FIFO_FULL_ERRORS_MASK) {
-		hw->rx_list_sts[0] &= ~rx_y_mask;
-		hw->rx_list_sts[0] |= rx_y_error;
-		tmp &= ~MISC1_Y_RX_ERROR_STATUS_RX_L0_FIFO_FULL_ERRORS_MASK;
-	}
-
-	if (tmp) {
-		hw->rx_list_sts[0] &= ~rx_y_mask;
-		hw->rx_list_sts[0] |= rx_y_error;
-		hw->rx_list_post_index = 0;
-	}
-
-	/* UV0 - DMA */
-	tmp = uv_err_sts & GET_UV0_ERR_MSK;
-	if (int_sts & INTR_INTR_STATUS_L0_UV_RX_DMA_DONE_INTR_MASK)
-		hw->rx_list_sts[0] &= ~rx_waiting_uv_intr;
-
-	if (uv_err_sts & MISC1_UV_RX_ERROR_STATUS_RX_L0_UNDERRUN_ERROR_MASK) {
-		hw->rx_list_sts[0] &= ~rx_waiting_uv_intr;
-		tmp &= ~MISC1_UV_RX_ERROR_STATUS_RX_L0_UNDERRUN_ERROR_MASK;
-	}
-
-	if (uv_err_sts &
-	 MISC1_UV_RX_ERROR_STATUS_RX_L0_FIFO_FULL_ERRORS_MASK) {
-		hw->rx_list_sts[0] &= ~rx_uv_mask;
-		hw->rx_list_sts[0] |= rx_uv_error;
-		tmp &= ~MISC1_UV_RX_ERROR_STATUS_RX_L0_FIFO_FULL_ERRORS_MASK;
-	}
-
-	if (tmp) {
-		hw->rx_list_sts[0] &= ~rx_uv_mask;
-		hw->rx_list_sts[0] |= rx_uv_error;
-		hw->rx_list_post_index = 0;
-	}
-
-	if (y_err_sts & GET_Y0_ERR_MSK) {
-		tmp = y_err_sts & GET_Y0_ERR_MSK;
-		crystalhd_reg_wr(hw->adp, MISC1_Y_RX_ERROR_STATUS, tmp);
-	}
-
-	if (uv_err_sts & GET_UV0_ERR_MSK) {
-		tmp = uv_err_sts & GET_UV0_ERR_MSK;
-		crystalhd_reg_wr(hw->adp, MISC1_UV_RX_ERROR_STATUS, tmp);
-	}
-
-	return (tmp_lsts != hw->rx_list_sts[0]);
-}
-
-static bool crystalhd_rx_list1_handler(struct crystalhd_hw *hw,
-		 uint32_t int_sts, uint32_t y_err_sts, uint32_t uv_err_sts)
-{
-	uint32_t tmp;
-	enum list_sts tmp_lsts;
-
-	if (!(y_err_sts & GET_Y1_ERR_MSK) && !(uv_err_sts & GET_UV1_ERR_MSK))
-		return false;
-
-	tmp_lsts = hw->rx_list_sts[1];
-
-	/* Y1 - DMA */
-	tmp = y_err_sts & GET_Y1_ERR_MSK;
-	if (int_sts & INTR_INTR_STATUS_L1_Y_RX_DMA_DONE_INTR_MASK)
-		hw->rx_list_sts[1] &= ~rx_waiting_y_intr;
-
-	if (y_err_sts & MISC1_Y_RX_ERROR_STATUS_RX_L1_UNDERRUN_ERROR_MASK) {
-		hw->rx_list_sts[1] &= ~rx_waiting_y_intr;
-		tmp &= ~MISC1_Y_RX_ERROR_STATUS_RX_L1_UNDERRUN_ERROR_MASK;
-	}
-
-	if (y_err_sts & MISC1_Y_RX_ERROR_STATUS_RX_L1_FIFO_FULL_ERRORS_MASK) {
-		/* Add retry-support..*/
-		hw->rx_list_sts[1] &= ~rx_y_mask;
-		hw->rx_list_sts[1] |= rx_y_error;
-		tmp &= ~MISC1_Y_RX_ERROR_STATUS_RX_L1_FIFO_FULL_ERRORS_MASK;
-	}
-
-	if (tmp) {
-		hw->rx_list_sts[1] &= ~rx_y_mask;
-		hw->rx_list_sts[1] |= rx_y_error;
-		hw->rx_list_post_index = 0;
-	}
-
-	/* UV1 - DMA */
-	tmp = uv_err_sts & GET_UV1_ERR_MSK;
-	if (int_sts & INTR_INTR_STATUS_L1_UV_RX_DMA_DONE_INTR_MASK)
-		hw->rx_list_sts[1] &= ~rx_waiting_uv_intr;
-
-	if (uv_err_sts & MISC1_UV_RX_ERROR_STATUS_RX_L1_UNDERRUN_ERROR_MASK) {
-		hw->rx_list_sts[1] &= ~rx_waiting_uv_intr;
-		tmp &= ~MISC1_UV_RX_ERROR_STATUS_RX_L1_UNDERRUN_ERROR_MASK;
-	}
-
-	if (uv_err_sts & MISC1_UV_RX_ERROR_STATUS_RX_L1_FIFO_FULL_ERRORS_MASK) {
-		/* Add retry-support*/
-		hw->rx_list_sts[1] &= ~rx_uv_mask;
-		hw->rx_list_sts[1] |= rx_uv_error;
-		tmp &= ~MISC1_UV_RX_ERROR_STATUS_RX_L1_FIFO_FULL_ERRORS_MASK;
-	}
-
-	if (tmp) {
-		hw->rx_list_sts[1] &= ~rx_uv_mask;
-		hw->rx_list_sts[1] |= rx_uv_error;
-		hw->rx_list_post_index = 0;
-	}
-
-	if (y_err_sts & GET_Y1_ERR_MSK) {
-		tmp = y_err_sts & GET_Y1_ERR_MSK;
-		crystalhd_reg_wr(hw->adp, MISC1_Y_RX_ERROR_STATUS, tmp);
-	}
-
-	if (uv_err_sts & GET_UV1_ERR_MSK) {
-		tmp = uv_err_sts & GET_UV1_ERR_MSK;
-		crystalhd_reg_wr(hw->adp, MISC1_UV_RX_ERROR_STATUS, tmp);
-	}
-
-	return (tmp_lsts != hw->rx_list_sts[1]);
-}
-
-
-static void crystalhd_rx_isr(struct crystalhd_hw *hw, uint32_t intr_sts)
-{
-	unsigned long flags;
-	uint32_t i, list_avail = 0;
-	enum BC_STATUS comp_sts = BC_STS_NO_DATA;
-	uint32_t y_err_sts, uv_err_sts, y_dn_sz = 0, uv_dn_sz = 0;
-	bool ret = 0;
-
-	if (!hw) {
-		BCMLOG_ERR("Invalid Arguments\n");
-		return;
-	}
-
-	if (!(intr_sts & GET_RX_INTR_MASK))
-		return;
-
-	y_err_sts = crystalhd_reg_rd(hw->adp, MISC1_Y_RX_ERROR_STATUS);
-	uv_err_sts = crystalhd_reg_rd(hw->adp, MISC1_UV_RX_ERROR_STATUS);
-
-	for (i = 0; i < DMA_ENGINE_CNT; i++) {
-		/* Update States..*/
-		spin_lock_irqsave(&hw->rx_lock, flags);
-		if (i == 0)
-			ret = crystalhd_rx_list0_handler(hw, intr_sts,
-					 y_err_sts, uv_err_sts);
-		else
-			ret = crystalhd_rx_list1_handler(hw, intr_sts,
-					 y_err_sts, uv_err_sts);
-		if (ret) {
-			switch (hw->rx_list_sts[i]) {
-			case sts_free:
-				comp_sts = BC_STS_SUCCESS;
-				list_avail = 1;
-				break;
-			case rx_y_error:
-			case rx_uv_error:
-			case rx_sts_error:
-				/* We got error on both or Y or uv. */
-				hw->stats.rx_errors++;
-				crystalhd_get_dnsz(hw, i, &y_dn_sz, &uv_dn_sz);
-				/* FIXME: jarod: this is where
-				 my mini pci-e card is tripping up */
-				BCMLOG(BCMLOG_DBG, "list_index:%x rx[%d] Y:%x UV:%x Int:%x YDnSz:%x UVDnSz:%x\n",
-				       i, hw->stats.rx_errors, y_err_sts,
-				       uv_err_sts, intr_sts, y_dn_sz,
-				       uv_dn_sz);
-				hw->rx_list_sts[i] = sts_free;
-				comp_sts = BC_STS_ERROR;
-				break;
-			default:
-				/* Wait for completion..*/
-				comp_sts = BC_STS_NO_DATA;
-				break;
-			}
-		}
-		spin_unlock_irqrestore(&hw->rx_lock, flags);
-
-		/* handle completion...*/
-		if (comp_sts != BC_STS_NO_DATA) {
-			crystalhd_rx_pkt_done(hw, i, comp_sts);
-			comp_sts = BC_STS_NO_DATA;
-		}
-	}
-
-	if (list_avail) {
-		if (hw->stop_pending) {
-			if ((hw->rx_list_sts[0] == sts_free) &&
-			    (hw->rx_list_sts[1] == sts_free))
-				crystalhd_hw_finalize_pause(hw);
-		} else {
-			crystalhd_hw_start_capture(hw);
-		}
-	}
-}
-
-static enum BC_STATUS crystalhd_fw_cmd_post_proc(struct crystalhd_hw *hw,
-					  struct BC_FW_CMD *fw_cmd)
-{
-	enum BC_STATUS sts = BC_STS_SUCCESS;
-	struct dec_rsp_channel_start_video *st_rsp = NULL;
-
-	switch (fw_cmd->cmd[0]) {
-	case eCMD_C011_DEC_CHAN_START_VIDEO:
-		st_rsp = (struct dec_rsp_channel_start_video *)fw_cmd->rsp;
-		hw->pib_del_Q_addr = st_rsp->picInfoDeliveryQ;
-		hw->pib_rel_Q_addr = st_rsp->picInfoReleaseQ;
-		BCMLOG(BCMLOG_DBG, "DelQAddr:%x RelQAddr:%x\n",
-		       hw->pib_del_Q_addr, hw->pib_rel_Q_addr);
-		break;
-	case eCMD_C011_INIT:
-		if (!(crystalhd_load_firmware_config(hw->adp))) {
-			BCMLOG_ERR("Invalid Params.\n");
-			sts = BC_STS_FW_AUTH_FAILED;
-		}
-		break;
-	default:
-		break;
-	}
-	return sts;
-}
-
-static enum BC_STATUS crystalhd_put_ddr2sleep(struct crystalhd_hw *hw)
-{
-	uint32_t reg;
-	union link_misc_perst_decoder_ctrl rst_cntrl_reg;
-
-	/* Pulse reset pin of 7412 (MISC_PERST_DECODER_CTRL) */
-	rst_cntrl_reg.whole_reg = crystalhd_reg_rd(hw->adp,
-					 MISC_PERST_DECODER_CTRL);
-
-	rst_cntrl_reg.bcm_7412_rst = 1;
-	crystalhd_reg_wr(hw->adp, MISC_PERST_DECODER_CTRL,
-					 rst_cntrl_reg.whole_reg);
-	msleep_interruptible(50);
-
-	rst_cntrl_reg.bcm_7412_rst = 0;
-	crystalhd_reg_wr(hw->adp, MISC_PERST_DECODER_CTRL,
-					 rst_cntrl_reg.whole_reg);
-
-	/* Close all banks, put DDR in idle */
-	bc_dec_reg_wr(hw->adp, SDRAM_PRECHARGE, 0);
-
-	/* Set bit 25 (drop CKE pin of DDR) */
-	reg = bc_dec_reg_rd(hw->adp, SDRAM_PARAM);
-	reg |= 0x02000000;
-	bc_dec_reg_wr(hw->adp, SDRAM_PARAM, reg);
-
-	/* Reset the audio block */
-	bc_dec_reg_wr(hw->adp, AUD_DSP_MISC_SOFT_RESET, 0x1);
-
-	/* Power down Raptor PLL */
-	reg = bc_dec_reg_rd(hw->adp, DecHt_PllCCtl);
-	reg |= 0x00008000;
-	bc_dec_reg_wr(hw->adp, DecHt_PllCCtl, reg);
-
-	/* Power down all Audio PLL */
-	bc_dec_reg_wr(hw->adp, AIO_MISC_PLL_RESET, 0x1);
-
-	/* Power down video clock (75MHz) */
-	reg = bc_dec_reg_rd(hw->adp, DecHt_PllECtl);
-	reg |= 0x00008000;
-	bc_dec_reg_wr(hw->adp, DecHt_PllECtl, reg);
-
-	/* Power down video clock (75MHz) */
-	reg = bc_dec_reg_rd(hw->adp, DecHt_PllDCtl);
-	reg |= 0x00008000;
-	bc_dec_reg_wr(hw->adp, DecHt_PllDCtl, reg);
-
-	/* Power down core clock (200MHz) */
-	reg = bc_dec_reg_rd(hw->adp, DecHt_PllACtl);
-	reg |= 0x00008000;
-	bc_dec_reg_wr(hw->adp, DecHt_PllACtl, reg);
-
-	/* Power down core clock (200MHz) */
-	reg = bc_dec_reg_rd(hw->adp, DecHt_PllBCtl);
-	reg |= 0x00008000;
-	bc_dec_reg_wr(hw->adp, DecHt_PllBCtl, reg);
-
-	return BC_STS_SUCCESS;
-}
-
-/************************************************
-**
-*************************************************/
-
-enum BC_STATUS crystalhd_download_fw(struct crystalhd_adp *adp, void *buffer,
-					 uint32_t sz)
-{
-	uint32_t reg_data, cnt, *temp_buff;
-	uint32_t fw_sig_len = 36;
-	uint32_t dram_offset = BC_FWIMG_ST_ADDR, sig_reg;
-
-
-	if (!adp || !buffer || !sz) {
-		BCMLOG_ERR("Invalid Params.\n");
-		return BC_STS_INV_ARG;
-	}
-
-	reg_data = crystalhd_reg_rd(adp, OTP_CMD);
-	if (!(reg_data & 0x02)) {
-		BCMLOG_ERR("Invalid hw config.. otp not programmed\n");
-		return BC_STS_ERROR;
-	}
-
-	reg_data = 0;
-	crystalhd_reg_wr(adp, DCI_CMD, 0);
-	reg_data |= BC_BIT(0);
-	crystalhd_reg_wr(adp, DCI_CMD, reg_data);
-
-	reg_data = 0;
-	cnt = 1000;
-	msleep_interruptible(10);
-
-	while (reg_data != BC_BIT(4)) {
-		reg_data = crystalhd_reg_rd(adp, DCI_STATUS);
-		reg_data &= BC_BIT(4);
-		if (--cnt == 0) {
-			BCMLOG_ERR("Firmware Download RDY Timeout.\n");
-			return BC_STS_TIMEOUT;
-		}
-	}
-
-	msleep_interruptible(10);
-	/*  Load the FW to the FW_ADDR field in the DCI_FIRMWARE_ADDR */
-	crystalhd_reg_wr(adp, DCI_FIRMWARE_ADDR, dram_offset);
-	temp_buff = (uint32_t *)buffer;
-	for (cnt = 0; cnt < (sz - fw_sig_len); cnt += 4) {
-		crystalhd_reg_wr(adp, DCI_DRAM_BASE_ADDR, (dram_offset >> 19));
-		crystalhd_reg_wr(adp, DCI_FIRMWARE_DATA, *temp_buff);
-		dram_offset += 4;
-		temp_buff++;
-	}
-	msleep_interruptible(10);
-
-	temp_buff++;
-
-	sig_reg = (uint32_t)DCI_SIGNATURE_DATA_7;
-	for (cnt = 0; cnt < 8; cnt++) {
-		uint32_t swapped_data = *temp_buff;
-		swapped_data = bswap_32_1(swapped_data);
-		crystalhd_reg_wr(adp, sig_reg, swapped_data);
-		sig_reg -= 4;
-		temp_buff++;
-	}
-	msleep_interruptible(10);
-
-	reg_data = 0;
-	reg_data |= BC_BIT(1);
-	crystalhd_reg_wr(adp, DCI_CMD, reg_data);
-	msleep_interruptible(10);
-
-	reg_data = 0;
-	reg_data = crystalhd_reg_rd(adp, DCI_STATUS);
-
-	if ((reg_data & BC_BIT(9)) == BC_BIT(9)) {
-		cnt = 1000;
-		while ((reg_data & BC_BIT(0)) != BC_BIT(0)) {
-			reg_data = crystalhd_reg_rd(adp, DCI_STATUS);
-			reg_data &= BC_BIT(0);
-			if (!(--cnt))
-				break;
-			msleep_interruptible(10);
-		}
-		reg_data = 0;
-		reg_data = crystalhd_reg_rd(adp, DCI_CMD);
-		reg_data |= BC_BIT(4);
-		crystalhd_reg_wr(adp, DCI_CMD, reg_data);
-
-	} else {
-		BCMLOG_ERR("F/w Signature mismatch\n");
-		return BC_STS_FW_AUTH_FAILED;
-	}
-
-	BCMLOG(BCMLOG_INFO, "Firmware Downloaded Successfully\n");
-	return BC_STS_SUCCESS;
-}
-
-enum BC_STATUS crystalhd_do_fw_cmd(struct crystalhd_hw *hw,
-				struct BC_FW_CMD *fw_cmd)
-{
-	uint32_t cnt = 0, cmd_res_addr;
-	uint32_t *cmd_buff, *res_buff;
-	wait_queue_head_t fw_cmd_event;
-	int rc = 0;
-	enum BC_STATUS sts;
-
-	crystalhd_create_event(&fw_cmd_event);
-
-	if (!hw || !fw_cmd) {
-		BCMLOG_ERR("Invalid Arguments\n");
-		return BC_STS_INV_ARG;
-	}
-
-	cmd_buff = fw_cmd->cmd;
-	res_buff = fw_cmd->rsp;
-
-	if (!cmd_buff || !res_buff) {
-		BCMLOG_ERR("Invalid Parameters for F/W Command\n");
-		return BC_STS_INV_ARG;
-	}
-
-	hw->pwr_lock++;
-
-	hw->fwcmd_evt_sts = 0;
-	hw->pfw_cmd_event = &fw_cmd_event;
-
-	/*Write the command to the memory*/
-	crystalhd_mem_wr(hw->adp, TS_Host2CpuSnd, FW_CMD_BUFF_SZ, cmd_buff);
-
-	/*Memory Read for memory arbitrator flush*/
-	crystalhd_mem_rd(hw->adp, TS_Host2CpuSnd, 1, &cnt);
-
-	/* Write the command address to mailbox */
-	bc_dec_reg_wr(hw->adp, Hst2CpuMbx1, TS_Host2CpuSnd);
-	msleep_interruptible(50);
-
-	crystalhd_wait_on_event(&fw_cmd_event, hw->fwcmd_evt_sts, 20000, rc, 0);
-
-	if (!rc) {
-		sts = BC_STS_SUCCESS;
-	} else if (rc == -EBUSY) {
-		BCMLOG_ERR("Firmware command T/O\n");
-		sts = BC_STS_TIMEOUT;
-	} else if (rc == -EINTR) {
-		BCMLOG(BCMLOG_DBG, "FwCmd Wait Signal int.\n");
-		sts = BC_STS_IO_USER_ABORT;
-	} else {
-		BCMLOG_ERR("FwCmd IO Error.\n");
-		sts = BC_STS_IO_ERROR;
-	}
-
-	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("FwCmd Failed.\n");
-		hw->pwr_lock--;
-		return sts;
-	}
-
-	/*Get the Response Address*/
-	cmd_res_addr = bc_dec_reg_rd(hw->adp, Cpu2HstMbx1);
-
-	/*Read the Response*/
-	crystalhd_mem_rd(hw->adp, cmd_res_addr, FW_CMD_BUFF_SZ, res_buff);
-
-	hw->pwr_lock--;
-
-	if (res_buff[2] != C011_RET_SUCCESS) {
-		BCMLOG_ERR("res_buff[2] != C011_RET_SUCCESS\n");
-		return BC_STS_FW_CMD_ERR;
-	}
-
-	sts = crystalhd_fw_cmd_post_proc(hw, fw_cmd);
-	if (sts != BC_STS_SUCCESS)
-		BCMLOG_ERR("crystalhd_fw_cmd_post_proc Failed.\n");
-
-	return sts;
-}
-
-bool crystalhd_hw_interrupt(struct crystalhd_adp *adp, struct crystalhd_hw *hw)
-{
-	uint32_t intr_sts = 0;
-	uint32_t deco_intr = 0;
-	bool rc = 0;
-
-	if (!adp || !hw->dev_started)
-		return rc;
-
-	hw->stats.num_interrupts++;
-	hw->pwr_lock++;
-
-	deco_intr = bc_dec_reg_rd(adp, Stream2Host_Intr_Sts);
-	intr_sts  = crystalhd_reg_rd(adp, INTR_INTR_STATUS);
-
-	if (intr_sts) {
-		/* let system know we processed interrupt..*/
-		rc = 1;
-		hw->stats.dev_interrupts++;
+	rx_pkt = crystalhd_dioq_find_and_fetch(hw->rx_actq,
+	hw->rx_pkt_tag_seed + list_index);
+	if (!rx_pkt) {
+		dev_err(&hw->adp->pdev->dev, "Act-Q: PostIx:%x L0Sts:%x "
+		"L1Sts:%x current L:%x tag:%x comp:%x\n",
+				hw->rx_list_post_index, hw->rx_list_sts[0],
+				hw->rx_list_sts[1], list_index,
+				hw->rx_pkt_tag_seed + list_index, comp_sts);
+				return BC_STS_INV_ARG;
 	}
 
-	if (deco_intr && (deco_intr != 0xdeaddead)) {
+	if (comp_sts == BC_STS_SUCCESS)
+	{
+		hw->DrvTotalFrmCaptured++;
 
-		if (deco_intr & 0x80000000) {
-			/*Set the Event and the status flag*/
-			if (hw->pfw_cmd_event) {
-				hw->fwcmd_evt_sts = 1;
-				crystalhd_set_event(hw->pfw_cmd_event);
+		hw->pfnHWGetDoneSize(hw, list_index, &y_dw_dnsz, &uv_dw_dnsz);
+		rx_pkt->dio_req->uinfo.y_done_sz = y_dw_dnsz;
+		rx_pkt->flags = COMP_FLAG_DATA_VALID;
+		if (rx_pkt->uv_phy_addr)
+			rx_pkt->dio_req->uinfo.uv_done_sz = uv_dw_dnsz;
+		crystalhd_dioq_add(hw->rx_rdyq, rx_pkt, true,
+							hw->rx_pkt_tag_seed + list_index);
+
+		if( hw->adp->pdev->device == BC_PCI_DEVID_FLEA)
+		{
+			/*printk("pre-PD state %x RLL %x Ptsh %x ratio %d currentPS %d\n", */
+			/*	hw->FleaPowerState, crystalhd_dioq_count(hw->rx_rdyq) , hw->PauseThreshold, hw->PDRatio, hw->FleaPowerState); */
+			if(hw->FleaPowerState == FLEA_PS_ACTIVE)
+			{
+				if(crystalhd_dioq_count(hw->rx_rdyq) >= hw->PauseThreshold)
+				{
+					hw->pfnIssuePause(hw, true);
+					hw->hw_pause_issued = true;
+				}
+				/* NAREN check if the PD ratio is less than 50. If so, try to reduce the PauseThreshold to improve the ratio */
+				/* never go lower than 6 pictures */
+				/* Only do this when we have some data to determine PDRatio */
+				/* For now assume that if we have captured 100 pictures then we should have enough data for the analysis to start */
+				if((hw->PDRatio < 50) && (hw->PauseThreshold > 6) && (hw->DrvTotalFrmCaptured > 100))
+				{
+					/*printk("Current PDRatio:%u, PauseThreshold:%u, DrvTotalFrmCaptured:%u  decress PauseThreshold\n", */
+					/*	hw->PDRatio, hw->PauseThreshold, hw->DrvTotalFrmCaptured); */
+					hw->PauseThreshold--;
+				}
+				else {
+					rdtscll(currTick);
+
+					temp_64 = (hw->TickSpentInPD)>>24;
+					TickSpentInPD_Hi = (uint32_t)(temp_64);
+					TickSpentInPD_Hi_f = (int32_t)TickSpentInPD_Hi;
+
+					temp_64 = (currTick - hw->TickCntDecodePU)>>24;
+					totalTick_Hi = (uint32_t)(temp_64);
+					totalTick_Hi_f = (int32_t)totalTick_Hi;
+
+					if( totalTick_Hi_f <= 0 )
+					{
+						temp_64 = (hw->TickSpentInPD);
+						TickSpentInPD_Hi = (uint32_t)(temp_64);
+						TickSpentInPD_Hi_f = (int32_t)TickSpentInPD_Hi;
+
+						temp_64 = (currTick - hw->TickCntDecodePU);
+						totalTick_Hi = (uint32_t)(temp_64);
+						totalTick_Hi_f = (int32_t)totalTick_Hi;
+					}
+
+					if( totalTick_Hi_f <= 0 )
+					{
+						printk("totalTick_Hi_f <= 0, set hw->PDRatio = 60\n");
+						hw->PDRatio = 60;
+					}
+					else
+						hw->PDRatio = (TickSpentInPD_Hi_f * 100) / totalTick_Hi_f;
+
+					/*printk("Current PDRatio:%u, PauseThreshold:%u, DrvTotalFrmCaptured:%u  don't decress PauseThreshold\n", */
+					/*	hw->PDRatio, hw->PauseThreshold, hw->DrvTotalFrmCaptured); */
+
+					/*hw->PDRatio = ((uint32_t)(hw->TickSpentInPD))/((uint32_t)(currTick - hw->TickCntDecodePU)/100); */
+				}
 			}
 		}
-
-		if (deco_intr & BC_BIT(1))
-			crystalhd_hw_proc_pib(hw);
-
-		bc_dec_reg_wr(adp, Stream2Host_Intr_Sts, deco_intr);
-		/* FIXME: jarod: No udelay? might this be
-		 the real reason mini pci-e cards were stalling out? */
-		bc_dec_reg_wr(adp, Stream2Host_Intr_Sts, 0);
-		rc = 1;
-	}
-
-	/* Rx interrupts */
-	crystalhd_rx_isr(hw, intr_sts);
-
-	/* Tx interrupts*/
-	crystalhd_tx_isr(hw, intr_sts);
-
-	/* Clear interrupts */
-	if (rc) {
-		if (intr_sts)
-			crystalhd_reg_wr(adp, INTR_INTR_CLR_REG, intr_sts);
-
-		crystalhd_reg_wr(adp, INTR_EOI_CTRL, 1);
-	}
-
-	hw->pwr_lock--;
-
-	return rc;
-}
-
-enum BC_STATUS crystalhd_hw_open(struct crystalhd_hw *hw,
-			 struct crystalhd_adp *adp)
-{
-	if (!hw || !adp) {
-		BCMLOG_ERR("Invalid Arguments\n");
-		return BC_STS_INV_ARG;
-	}
-
-	if (hw->dev_started)
-		return BC_STS_SUCCESS;
-
-	memset(hw, 0, sizeof(struct crystalhd_hw));
-
-	hw->adp = adp;
-	spin_lock_init(&hw->lock);
-	spin_lock_init(&hw->rx_lock);
-	/* FIXME: jarod: what are these magic numbers?!? */
-	hw->tx_ioq_tag_seed = 0x70023070;
-	hw->rx_pkt_tag_seed = 0x70029070;
-
-	hw->stop_pending = 0;
-	crystalhd_start_device(hw->adp);
-	hw->dev_started = true;
-
-	/* set initial core clock  */
-	hw->core_clock_mhz = CLOCK_PRESET;
-	hw->prev_n = 0;
-	hw->pwr_lock = 0;
-	crystalhd_hw_set_core_clock(hw);
-
-	return BC_STS_SUCCESS;
-}
-
-enum BC_STATUS crystalhd_hw_close(struct crystalhd_hw *hw)
-{
-	if (!hw) {
-		BCMLOG_ERR("Invalid Arguments\n");
-		return BC_STS_INV_ARG;
-	}
-
-	if (!hw->dev_started)
-		return BC_STS_SUCCESS;
-
-	/* Stop and DDR sleep will happen in here */
-	crystalhd_hw_suspend(hw);
-	hw->dev_started = false;
-
-	return BC_STS_SUCCESS;
-}
-
-enum BC_STATUS crystalhd_hw_setup_dma_rings(struct crystalhd_hw *hw)
-{
-	unsigned int i;
-	void *mem;
-	size_t mem_len;
-	dma_addr_t phy_addr;
-	enum BC_STATUS sts = BC_STS_SUCCESS;
-	struct crystalhd_rx_dma_pkt *rpkt;
-
-	if (!hw || !hw->adp) {
-		BCMLOG_ERR("Invalid Arguments\n");
-		return BC_STS_INV_ARG;
-	}
-
-	sts = crystalhd_hw_create_ioqs(hw);
-	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("Failed to create IOQs..\n");
-		return sts;
-	}
-
-	mem_len = BC_LINK_MAX_SGLS * sizeof(struct dma_descriptor);
-
-	for (i = 0; i < BC_TX_LIST_CNT; i++) {
-		mem = bc_kern_dma_alloc(hw->adp, mem_len, &phy_addr);
-		if (mem) {
-			memset(mem, 0, mem_len);
-		} else {
-			BCMLOG_ERR("Insufficient Memory For TX\n");
-			crystalhd_hw_free_dma_rings(hw);
-			return BC_STS_INSUFF_RES;
-		}
-		/* rx_pkt_pool -- static memory allocation  */
-		hw->tx_pkt_pool[i].desc_mem.pdma_desc_start = mem;
-		hw->tx_pkt_pool[i].desc_mem.phy_addr = phy_addr;
-		hw->tx_pkt_pool[i].desc_mem.sz = BC_LINK_MAX_SGLS *
-						 sizeof(struct dma_descriptor);
-		hw->tx_pkt_pool[i].list_tag = 0;
-
-		/* Add TX dma requests to Free Queue..*/
-		sts = crystalhd_dioq_add(hw->tx_freeq,
-				       &hw->tx_pkt_pool[i], false, 0);
-		if (sts != BC_STS_SUCCESS) {
-			crystalhd_hw_free_dma_rings(hw);
-			return sts;
-		}
-	}
-
-	for (i = 0; i < BC_RX_LIST_CNT; i++) {
-		rpkt = kzalloc(sizeof(*rpkt), GFP_KERNEL);
-		if (!rpkt) {
-			BCMLOG_ERR("Insufficient Memory For RX\n");
-			crystalhd_hw_free_dma_rings(hw);
-			return BC_STS_INSUFF_RES;
-		}
-
-		mem = bc_kern_dma_alloc(hw->adp, mem_len, &phy_addr);
-		if (mem) {
-			memset(mem, 0, mem_len);
-		} else {
-			BCMLOG_ERR("Insufficient Memory For RX\n");
-			crystalhd_hw_free_dma_rings(hw);
-			kfree(rpkt);
-			return BC_STS_INSUFF_RES;
+		else if( hw->hw_pause_issued == false )
+		{
+#if 0
+			if(crystalhd_dioq_count(hw->rx_rdyq) > hw->PauseThreshold)/*HW_PAUSE_THRESHOLD */
+			{
+				dev_info(&hw->adp->pdev->dev, "HW PAUSE\n");
+				hw->pfnIssuePause(hw, true);
+				hw->hw_pause_issued = true;
+			}
+#endif
 		}
-		rpkt->desc_mem.pdma_desc_start = mem;
-		rpkt->desc_mem.phy_addr = phy_addr;
-		rpkt->desc_mem.sz  = BC_LINK_MAX_SGLS *
-					 sizeof(struct dma_descriptor);
-		rpkt->pkt_tag = hw->rx_pkt_tag_seed + i;
-		crystalhd_hw_free_rx_pkt(hw, rpkt);
-	}
-
-	return BC_STS_SUCCESS;
-}
-
-enum BC_STATUS crystalhd_hw_free_dma_rings(struct crystalhd_hw *hw)
-{
-	unsigned int i;
-	struct crystalhd_rx_dma_pkt *rpkt = NULL;
-
-	if (!hw || !hw->adp) {
-		BCMLOG_ERR("Invalid Arguments\n");
-		return BC_STS_INV_ARG;
-	}
 
-	/* Delete all IOQs.. */
-	crystalhd_hw_delete_ioqs(hw);
-
-	for (i = 0; i < BC_TX_LIST_CNT; i++) {
-		if (hw->tx_pkt_pool[i].desc_mem.pdma_desc_start) {
-			bc_kern_dma_free(hw->adp,
-				hw->tx_pkt_pool[i].desc_mem.sz,
-				hw->tx_pkt_pool[i].desc_mem.pdma_desc_start,
-				hw->tx_pkt_pool[i].desc_mem.phy_addr);
-
-			hw->tx_pkt_pool[i].desc_mem.pdma_desc_start = NULL;
-		}
+		return sts;
 	}
-
-	BCMLOG(BCMLOG_DBG, "Releasing RX Pkt pool\n");
-	do {
-		rpkt = crystalhd_hw_alloc_rx_pkt(hw);
-		if (!rpkt)
-			break;
-		bc_kern_dma_free(hw->adp, rpkt->desc_mem.sz,
-				 rpkt->desc_mem.pdma_desc_start,
-				 rpkt->desc_mem.phy_addr);
-		kfree(rpkt);
-	} while (rpkt);
-
-	return BC_STS_SUCCESS;
+	/* Check if we can post this DIO again. */
+	return hw->pfnPostRxSideBuff(hw, rx_pkt);
 }
 
-enum BC_STATUS crystalhd_hw_post_tx(struct crystalhd_hw *hw,
-			     struct crystalhd_dio_req *ioreq,
+enum BC_STATUS crystalhd_hw_post_tx(struct crystalhd_hw *hw, struct crystalhd_dio_req *ioreq,
 			     hw_comp_callback call_back,
 			     wait_queue_head_t *cb_event, uint32_t *list_id,
 			     uint8_t data_flags)
 {
+	struct device *dev;
 	struct tx_dma_pkt *tx_dma_packet = NULL;
-	uint32_t first_desc_u_addr, first_desc_l_addr;
 	uint32_t low_addr, high_addr;
-	union addr_64 desc_addr;
+	addr_64 desc_addr;
 	enum BC_STATUS sts, add_sts;
 	uint32_t dummy_index = 0;
 	unsigned long flags;
+	uint8_t list_posted;
+	uint8_t local_flags = data_flags;
 	bool rc;
+	uint32_t destDRAMaddr = 0;
 
 	if (!hw || !ioreq || !call_back || !cb_event || !list_id) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
+	dev = &hw->adp->pdev->dev;
+
 	/*
 	 * Since we hit code in busy condition very frequently,
 	 * we will check the code in status first before
@@ -2098,35 +742,37 @@ enum BC_STATUS crystalhd_hw_post_tx(struct crystalhd_hw *hw,
 	 *
 	 * This will avoid the Q fetch/add in normal condition.
 	 */
-	rc = crystalhd_code_in_full(hw->adp, ioreq->uinfo.xfr_len,
-				  false, data_flags);
+
+	rc = hw->pfnCheckInputFIFO(hw, ioreq->uinfo.xfr_len,
+					   &dummy_index, false, &local_flags);
+
 	if (rc) {
 		hw->stats.cin_busy++;
 		return BC_STS_BUSY;
 	}
 
+	if(local_flags & BC_BIT(7))
+		destDRAMaddr = hw->TxFwInputBuffInfo.DramBuffAdd;
+
 	/* Get a list from TxFreeQ */
-	tx_dma_packet = (struct tx_dma_pkt *)crystalhd_dioq_fetch(
-						hw->tx_freeq);
+	tx_dma_packet = (struct tx_dma_pkt *)crystalhd_dioq_fetch(hw->tx_freeq);
 	if (!tx_dma_packet) {
-		BCMLOG_ERR("No empty elements..\n");
-		return BC_STS_ERR_USAGE;
+		dev_err(dev, "No empty elements..\n");
+		return BC_STS_INSUFF_RES;
 	}
 
 	sts = crystalhd_xlat_sgl_to_dma_desc(ioreq,
-					   &tx_dma_packet->desc_mem,
-					   &dummy_index);
+					     &tx_dma_packet->desc_mem,
+					     &dummy_index, dev, destDRAMaddr);
 	if (sts != BC_STS_SUCCESS) {
 		add_sts = crystalhd_dioq_add(hw->tx_freeq, tx_dma_packet,
 					   false, 0);
 		if (add_sts != BC_STS_SUCCESS)
-			BCMLOG_ERR("double fault..\n");
+			dev_err(dev, "double fault..\n");
 
 		return sts;
 	}
 
-	hw->pwr_lock++;
-
 	desc_addr.full_addr = tx_dma_packet->desc_mem.phy_addr;
 	low_addr = desc_addr.low_part;
 	high_addr = desc_addr.high_part;
@@ -2137,21 +783,20 @@ enum BC_STATUS crystalhd_hw_post_tx(struct crystalhd_hw *hw,
 
 	spin_lock_irqsave(&hw->lock, flags);
 
-	if (hw->tx_list_post_index == 0) {
-		first_desc_u_addr = MISC1_TX_FIRST_DESC_U_ADDR_LIST0;
-		first_desc_l_addr = MISC1_TX_FIRST_DESC_L_ADDR_LIST0;
-	} else {
-		first_desc_u_addr = MISC1_TX_FIRST_DESC_U_ADDR_LIST1;
-		first_desc_l_addr = MISC1_TX_FIRST_DESC_L_ADDR_LIST1;
-	}
+	list_posted = hw->tx_list_post_index;
 
 	*list_id = tx_dma_packet->list_tag = hw->tx_ioq_tag_seed +
 					     hw->tx_list_post_index;
 
-	hw->tx_list_post_index = (hw->tx_list_post_index + 1) % DMA_ENGINE_CNT;
 
-	spin_unlock_irqrestore(&hw->lock, flags);
+	if( hw->tx_list_post_index % DMA_ENGINE_CNT) {
+		hw->TxList1Sts |= TxListWaitingForIntr;
+	}
+	else {
+		hw->TxList0Sts |= TxListWaitingForIntr;
+	}
 
+	hw->tx_list_post_index = (hw->tx_list_post_index + 1) % DMA_ENGINE_CNT;
 
 	/* Insert in Active Q..*/
 	crystalhd_dioq_add(hw->tx_actq, tx_dma_packet, false,
@@ -2162,12 +807,13 @@ enum BC_STATUS crystalhd_hw_post_tx(struct crystalhd_hw *hw,
 	 * the valid bit. So be ready for that. All
 	 * the initialization should happen before that.
 	 */
-	crystalhd_start_tx_dma_engine(hw);
-	crystalhd_reg_wr(hw->adp, first_desc_u_addr, desc_addr.high_part);
 
-	crystalhd_reg_wr(hw->adp, first_desc_l_addr, desc_addr.low_part |
-					 0x01);
-					/* Be sure we set the valid bit ^^^^ */
+	/* Save the transfer length */
+	hw->TxFwInputBuffInfo.HostXferSzInBytes = ioreq->uinfo.xfr_len;
+
+	hw->pfnStartTxDMA(hw, list_posted, desc_addr);
+
+	spin_unlock_irqrestore(&hw->lock, flags);
 
 	return BC_STS_SUCCESS;
 }
@@ -2181,35 +827,37 @@ enum BC_STATUS crystalhd_hw_post_tx(struct crystalhd_hw *hw,
  *
  * FIX_ME: Not Tested the actual condition..
  */
-enum BC_STATUS crystalhd_hw_cancel_tx(struct crystalhd_hw *hw,
-					 uint32_t list_id)
+enum BC_STATUS crystalhd_hw_cancel_tx(struct crystalhd_hw *hw, uint32_t list_id)
 {
+	unsigned long flags;
 	if (!hw || !list_id) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
-	crystalhd_stop_tx_dma_engine(hw);
+	spin_lock_irqsave(&hw->lock, flags);
+	hw->pfnStopTxDMA(hw);
+	spin_unlock_irqrestore(&hw->lock, flags);
 	crystalhd_hw_tx_req_complete(hw, list_id, BC_STS_IO_USER_ABORT);
 
 	return BC_STS_SUCCESS;
 }
 
 enum BC_STATUS crystalhd_hw_add_cap_buffer(struct crystalhd_hw *hw,
-				 struct crystalhd_dio_req *ioreq, bool en_post)
+				    struct crystalhd_dio_req *ioreq, bool en_post)
 {
 	struct crystalhd_rx_dma_pkt *rpkt;
 	uint32_t tag, uv_desc_ix = 0;
 	enum BC_STATUS sts;
 
 	if (!hw || !ioreq) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	rpkt = crystalhd_hw_alloc_rx_pkt(hw);
 	if (!rpkt) {
-		BCMLOG_ERR("Insufficient resources\n");
+		dev_err(&hw->adp->pdev->dev, "Insufficient resources\n");
 		return BC_STS_INSUFF_RES;
 	}
 
@@ -2217,7 +865,7 @@ enum BC_STATUS crystalhd_hw_add_cap_buffer(struct crystalhd_hw *hw,
 	tag = rpkt->pkt_tag;
 
 	sts = crystalhd_xlat_sgl_to_dma_desc(ioreq, &rpkt->desc_mem,
-					 &uv_desc_ix);
+					     &uv_desc_ix, &hw->adp->pdev->dev, 0);
 	if (sts != BC_STS_SUCCESS)
 		return sts;
 
@@ -2226,35 +874,60 @@ enum BC_STATUS crystalhd_hw_add_cap_buffer(struct crystalhd_hw *hw,
 	/* Store the address of UV in the rx packet for post*/
 	if (uv_desc_ix)
 		rpkt->uv_phy_addr = rpkt->desc_mem.phy_addr +
-			 (sizeof(struct dma_descriptor) * (uv_desc_ix + 1));
+				    (sizeof(struct dma_descriptor) * (uv_desc_ix + 1));
 
-	if (en_post)
-		sts = crystalhd_hw_post_cap_buff(hw, rpkt);
-	else
+	if (en_post && !hw->hw_pause_issued) {
+		sts = hw->pfnPostRxSideBuff(hw, rpkt);
+	}
+	else {
 		sts = crystalhd_dioq_add(hw->rx_freeq, rpkt, false, tag);
+		hw->pfnNotifyFLLChange(hw, false);
+	}
 
 	return sts;
 }
 
 enum BC_STATUS crystalhd_hw_get_cap_buffer(struct crystalhd_hw *hw,
-				    struct BC_PIC_INFO_BLOCK *pib,
-				    struct crystalhd_dio_req **ioreq)
+										struct c011_pib *pib,
+										struct crystalhd_dio_req **ioreq)
 {
 	struct crystalhd_rx_dma_pkt *rpkt;
 	uint32_t timeout = BC_PROC_OUTPUT_TIMEOUT / 1000;
 	uint32_t sig_pending = 0;
 
-
 	if (!hw || !ioreq || !pib) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
-	rpkt = crystalhd_dioq_fetch_wait(hw->rx_rdyq, timeout, &sig_pending);
+	rpkt = crystalhd_dioq_fetch_wait(hw, timeout, &sig_pending);
+
+	if( hw->adp->pdev->device == BC_PCI_DEVID_FLEA)
+	{
+		/*printk("pre-PU state %x RLL %x Rtsh %x, currentPS %d,\n", */
+		/*	hw->FleaPowerState, crystalhd_dioq_count(hw->rx_rdyq) , hw->ResumeThreshold, hw->FleaPowerState); */
+		if( (hw->FleaPowerState == FLEA_PS_LP_PENDING) ||
+			(hw->FleaPowerState == FLEA_PS_LP_COMPLETE))
+		{
+			if(crystalhd_dioq_count(hw->rx_rdyq)  <= hw->ResumeThreshold)
+				hw->pfnIssuePause(hw, false);	/*Need this Notification For Flea*/
+				hw->hw_pause_issued = false;
+		}
+	}
+	else if( hw->hw_pause_issued)
+	{
+#if 0
+		if(crystalhd_dioq_count(hw->rx_rdyq) < hw->PauseThreshold ) /*HW_RESUME_THRESHOLD */
+		{
+			dev_info(&hw->adp->pdev->dev, "HW RESUME with rdy list %u \n",crystalhd_dioq_count(hw->rx_rdyq));
+			hw->pfnIssuePause(hw, false);
+			hw->hw_pause_issued = false;
+		}
+#endif
+	}
+
 	if (!rpkt) {
 		if (sig_pending) {
-			BCMLOG(BCMLOG_INFO, "wait on frame time out %d\n",
-					 sig_pending);
 			return BC_STS_IO_USER_ABORT;
 		} else {
 			return BC_STS_TIMEOUT;
@@ -2264,7 +937,19 @@ enum BC_STATUS crystalhd_hw_get_cap_buffer(struct crystalhd_hw *hw,
 	rpkt->dio_req->uinfo.comp_flags = rpkt->flags;
 
 	if (rpkt->flags & COMP_FLAG_PIB_VALID)
-		memcpy(pib, &rpkt->pib, sizeof(*pib));
+	{
+		pib->ppb.picture_number = rpkt->pib.picture_number;
+		pib->ppb.width = rpkt->pib.width;
+		pib->ppb.height = rpkt->pib.height;
+		pib->ppb.chroma_format = rpkt->pib.chroma_format;
+		pib->ppb.pulldown = rpkt->pib.pulldown;
+		pib->ppb.flags = rpkt->pib.flags;
+		pib->ptsStcOffset = rpkt->pib.sess_num;
+		pib->ppb.aspect_ratio = rpkt->pib.aspect_ratio;
+		pib->ppb.colour_primaries = rpkt->pib.colour_primaries;
+		pib->ppb.picture_meta_payload = rpkt->pib.picture_meta_payload;
+		pib->resolution = rpkt->pib.frame_rate;
+	}
 
 	*ioreq = rpkt->dio_req;
 
@@ -2280,7 +965,7 @@ enum BC_STATUS crystalhd_hw_start_capture(struct crystalhd_hw *hw)
 	uint32_t i;
 
 	if (!hw) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -2289,7 +974,7 @@ enum BC_STATUS crystalhd_hw_start_capture(struct crystalhd_hw *hw)
 		rx_pkt = crystalhd_dioq_fetch(hw->rx_freeq);
 		if (!rx_pkt)
 			return BC_STS_NO_DATA;
-		sts = crystalhd_hw_post_cap_buff(hw, rx_pkt);
+		sts = hw->pfnPostRxSideBuff(hw, rx_pkt);
 		if (BC_STS_SUCCESS != sts)
 			break;
 
@@ -2298,87 +983,90 @@ enum BC_STATUS crystalhd_hw_start_capture(struct crystalhd_hw *hw)
 	return BC_STS_SUCCESS;
 }
 
-enum BC_STATUS crystalhd_hw_stop_capture(struct crystalhd_hw *hw)
+enum BC_STATUS crystalhd_hw_stop_capture(struct crystalhd_hw *hw, bool unmap)
 {
 	void *temp = NULL;
 
 	if (!hw) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
-	crystalhd_stop_rx_dma_engine(hw);
+	hw->pfnStopRXDMAEngines(hw);
+
+	if(!unmap)
+		return BC_STS_SUCCESS;
 
+	/* Clear up Active, Ready and Free lists one by one and release resources */
 	do {
-		temp = crystalhd_dioq_fetch(hw->rx_freeq);
+		temp = crystalhd_dioq_fetch(hw->rx_actq);
 		if (temp)
 			crystalhd_rx_pkt_rel_call_back(hw, temp);
 	} while (temp);
 
-	return BC_STS_SUCCESS;
-}
-
-enum BC_STATUS crystalhd_hw_pause(struct crystalhd_hw *hw)
-{
-	hw->stats.pause_cnt++;
-	hw->stop_pending = 1;
+	do {
+		temp = crystalhd_dioq_fetch(hw->rx_rdyq);
+		if (temp)
+			crystalhd_rx_pkt_rel_call_back(hw, temp);
+	} while (temp);
 
-	if ((hw->rx_list_sts[0] == sts_free) &&
-	    (hw->rx_list_sts[1] == sts_free))
-		crystalhd_hw_finalize_pause(hw);
+	do {
+		temp = crystalhd_dioq_fetch(hw->rx_freeq);
+		if (temp)
+			crystalhd_rx_pkt_rel_call_back(hw, temp);
+	} while (temp);
 
 	return BC_STS_SUCCESS;
 }
 
-enum BC_STATUS crystalhd_hw_unpause(struct crystalhd_hw *hw)
+enum BC_STATUS crystalhd_hw_suspend(struct crystalhd_hw *hw)
 {
-	enum BC_STATUS sts;
-	uint32_t aspm;
-
-	hw->stop_pending = 0;
+	if (!hw) {
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
+		return BC_STS_INV_ARG;
+	}
 
-	aspm = crystalhd_reg_rd(hw->adp, PCIE_DLL_DATA_LINK_CONTROL);
-	aspm &= ~ASPM_L1_ENABLE;
-/* NAREN BCMLOG(BCMLOG_INFO, "aspm off\n"); */
-	crystalhd_reg_wr(hw->adp, PCIE_DLL_DATA_LINK_CONTROL, aspm);
+	if (!hw->pfnStopDevice(hw)) {
+		dev_info(&hw->adp->pdev->dev, "Failed to Stop Device!!\n");
+		return BC_STS_ERROR;
+	}
 
-	sts = crystalhd_hw_start_capture(hw);
-	return sts;
+	return BC_STS_SUCCESS;
 }
 
-enum BC_STATUS crystalhd_hw_suspend(struct crystalhd_hw *hw)
+enum BC_STATUS crystalhd_hw_resume(struct crystalhd_hw *hw)
 {
-	enum BC_STATUS sts;
-
 	if (!hw) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
-	sts = crystalhd_put_ddr2sleep(hw);
-	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("Failed to Put DDR To Sleep!!\n");
-		return BC_STS_ERROR;
-	}
+	// Reset list state
+	hw->rx_list_sts[0] = sts_free;
+	hw->rx_list_sts[1] = sts_free;
+	hw->TxList0Sts = ListStsFree;
+	hw->TxList1Sts = ListStsFree;
+	hw->rx_list_post_index = 0;
+	hw->tx_list_post_index = 0;
 
-	if (!crystalhd_stop_device(hw->adp)) {
-		BCMLOG_ERR("Failed to Stop Device!!\n");
+	if (hw->pfnStartDevice(hw)) {
+		dev_info(&hw->adp->pdev->dev, "Failed to Start Device!!\n");
 		return BC_STS_ERROR;
 	}
 
 	return BC_STS_SUCCESS;
 }
 
-void crystalhd_hw_stats(struct crystalhd_hw *hw,
-		 struct crystalhd_hw_stats *stats)
+void crystalhd_hw_stats(struct crystalhd_hw *hw, struct crystalhd_hw_stats *stats)
 {
 	if (!hw) {
-		BCMLOG_ERR("Invalid Arguments\n");
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
 		return;
 	}
 
 	/* if called w/NULL stats, its a req to zero out the stats */
 	if (!stats) {
+		hw->DrvTotalFrmCaptured = 0;
 		memset(&hw->stats, 0, sizeof(hw->stats));
 		return;
 	}
@@ -2387,70 +1075,3 @@ void crystalhd_hw_stats(struct crystalhd_hw *hw,
 	hw->stats.rdyq_count  = crystalhd_dioq_count(hw->rx_rdyq);
 	memcpy(stats, &hw->stats, sizeof(*stats));
 }
-
-enum BC_STATUS crystalhd_hw_set_core_clock(struct crystalhd_hw *hw)
-{
-	uint32_t reg, n, i;
-	uint32_t vco_mg, refresh_reg;
-
-	if (!hw) {
-		BCMLOG_ERR("Invalid Arguments\n");
-		return BC_STS_INV_ARG;
-	}
-
-	/* FIXME: jarod: wha? */
-	/*n = (hw->core_clock_mhz * 3) / 20 + 1; */
-	n = hw->core_clock_mhz/5;
-
-	if (n == hw->prev_n)
-		return BC_STS_CLK_NOCHG;
-
-	if (hw->pwr_lock > 0) {
-		/* BCMLOG(BCMLOG_INFO,"pwr_lock is %u\n", hw->pwr_lock) */
-		return BC_STS_CLK_NOCHG;
-	}
-
-	i = n * 27;
-	if (i < 560)
-		vco_mg = 0;
-	else if (i < 900)
-		vco_mg = 1;
-	else if (i < 1030)
-		vco_mg = 2;
-	else
-		vco_mg = 3;
-
-	reg = bc_dec_reg_rd(hw->adp, DecHt_PllACtl);
-
-	reg &= 0xFFFFCFC0;
-	reg |= n;
-	reg |= vco_mg << 12;
-
-	BCMLOG(BCMLOG_INFO, "clock is moving to %d with n %d with vco_mg %d\n",
-	       hw->core_clock_mhz, n, vco_mg);
-
-	/* Change the DRAM refresh rate to accommodate the new frequency */
-	/* refresh reg = ((refresh_rate * clock_rate)/16) - 1; rounding up*/
-	refresh_reg = (7 * hw->core_clock_mhz / 16);
-	bc_dec_reg_wr(hw->adp, SDRAM_REF_PARAM, ((1 << 12) | refresh_reg));
-
-	bc_dec_reg_wr(hw->adp, DecHt_PllACtl, reg);
-
-	i = 0;
-
-	for (i = 0; i < 10; i++) {
-		reg = bc_dec_reg_rd(hw->adp, DecHt_PllACtl);
-
-		if (reg & 0x00020000) {
-			hw->prev_n = n;
-			/* FIXME: jarod: outputting
-			 a random "C" is... confusing... */
-			BCMLOG(BCMLOG_INFO, "C");
-			return BC_STS_SUCCESS;
-		} else {
-			msleep_interruptible(10);
-		}
-	}
-	BCMLOG(BCMLOG_INFO, "clk change failed\n");
-	return BC_STS_CLK_NOCHG;
-}
diff --git a/drivers/staging/crystalhd/crystalhd_hw.h b/drivers/staging/crystalhd/crystalhd_hw.h
index 3780944..4f16cf3 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.h
+++ b/drivers/staging/crystalhd/crystalhd_hw.h
@@ -26,168 +26,46 @@
 
 #ifndef _CRYSTALHD_HW_H_
 #define _CRYSTALHD_HW_H_
+#define DEBUG 1
 
 #include "crystalhd.h"
 
+#include <linux/device.h>
+#include <linux/version.h>
+#include <linux/semaphore.h>
+#include "DriverFwShare.h"
+#include "FleaDefs.h"
+
 /* HW constants..*/
 #define DMA_ENGINE_CNT		2
 #define MAX_PIB_Q_DEPTH		64
 #define MIN_PIB_Q_DEPTH		2
 #define WR_POINTER_OFF		4
+#define MAX_VALID_POLL_CNT	1000
 
-#define ASPM_L1_ENABLE		(BC_BIT(27))
-
-/*************************************************
-  7412 Decoder  Registers.
-**************************************************/
-#define FW_CMD_BUFF_SZ		64
-#define TS_Host2CpuSnd		0x00000100
-#define Hst2CpuMbx1		0x00100F00
-#define Cpu2HstMbx1		0x00100F04
-#define MbxStat1		0x00100F08
-#define Stream2Host_Intr_Sts	0x00100F24
-#define C011_RET_SUCCESS	0x0 /* Reutrn status of firmware command. */
-
-/* TS input status register */
-#define TS_StreamAFIFOStatus	0x0010044C
-#define TS_StreamBFIFOStatus	0x0010084C
-
-/*UART Selection definitions*/
-#define UartSelectA		0x00100300
-#define UartSelectB		0x00100304
-
-#define BSVS_UART_DEC_NONE	0x00
-#define BSVS_UART_DEC_OUTER	0x01
-#define BSVS_UART_DEC_INNER	0x02
-#define BSVS_UART_STREAM	0x03
-
-/* Code-In fifo */
-#define REG_DecCA_RegCinCTL	0xa00
-#define REG_DecCA_RegCinBase	0xa0c
-#define REG_DecCA_RegCinEnd	0xa10
-#define REG_DecCA_RegCinWrPtr	0xa04
-#define REG_DecCA_RegCinRdPtr	0xa08
-
-#define REG_Dec_TsUser0Base	0x100864
-#define REG_Dec_TsUser0Rdptr	0x100868
-#define REG_Dec_TsUser0Wrptr	0x10086C
-#define REG_Dec_TsUser0End	0x100874
-
-/* ASF Case ...*/
-#define REG_Dec_TsAudCDB2Base	0x10036c
-#define REG_Dec_TsAudCDB2Rdptr  0x100378
-#define REG_Dec_TsAudCDB2Wrptr  0x100374
-#define REG_Dec_TsAudCDB2End	0x100370
-
-/* DRAM bringup Registers */
-#define SDRAM_PARAM		0x00040804
-#define SDRAM_PRECHARGE		0x000408B0
-#define SDRAM_EXT_MODE		0x000408A4
-#define SDRAM_MODE		0x000408A0
-#define SDRAM_REFRESH		0x00040890
-#define SDRAM_REF_PARAM		0x00040808
-
-#define DecHt_PllACtl		0x34000C
-#define DecHt_PllBCtl		0x340010
-#define DecHt_PllCCtl		0x340014
-#define DecHt_PllDCtl		0x340034
-#define DecHt_PllECtl		0x340038
-#define AUD_DSP_MISC_SOFT_RESET	0x00240104
-#define AIO_MISC_PLL_RESET	0x0026000C
-#define PCIE_CLK_REQ_REG	0xDC
-#define	PCI_CLK_REQ_ENABLE	(BC_BIT(8))
-
-/*************************************************
-  F/W Copy engine definitions..
-**************************************************/
-#define BC_FWIMG_ST_ADDR	0x00000000
-/* FIXME: jarod: there's a kernel function that'll do this for us... */
-#define rotr32_1(x, n)		(((x) >> n) | ((x) << (32 - n)))
-#define bswap_32_1(x) ((rotr32_1((x), 24) & 0x00ff00ff) | (rotr32_1((x), 8) & 0xff00ff00))
-
-#define DecHt_HostSwReset	0x340000
-#define BC_DRAM_FW_CFG_ADDR	0x001c2000
-
-union addr_64 {
-	struct {
-		uint32_t	low_part;
-		uint32_t	high_part;
-	};
-
-	uint64_t	full_addr;
-
-};
-
-union intr_mask_reg {
-	struct {
-		uint32_t	mask_tx_done:1;
-		uint32_t	mask_tx_err:1;
-		uint32_t	mask_rx_done:1;
-		uint32_t	mask_rx_err:1;
-		uint32_t	mask_pcie_err:1;
-		uint32_t	mask_pcie_rbusmast_err:1;
-		uint32_t	mask_pcie_rgr_bridge:1;
-		uint32_t	reserved:25;
-	};
-
-	uint32_t	whole_reg;
-
-};
-
-union link_misc_perst_deco_ctrl {
-	struct {
-		uint32_t	bcm7412_rst:1;	/* 1 -> BCM7412 is held
-						in reset. Reset value 1.*/
-		uint32_t	reserved0:3;		/* Reserved.No Effect*/
-		uint32_t	stop_bcm_7412_clk:1;	/* 1 ->Stops branch of
-						27MHz clk used to clk BCM7412*/
-		uint32_t	reserved1:27;		/* Reseved. No Effect*/
-	};
-
-	uint32_t	whole_reg;
-
-};
-
-union link_misc_perst_clk_ctrl {
-	struct {
-		uint32_t	sel_alt_clk:1;	  /* When set, selects a
-				 6.75MHz clock as the source of core_clk */
-		uint32_t	stop_core_clk:1;  /* When set, stops the branch
-		 of core_clk that is not needed for low power operation */
-		uint32_t	pll_pwr_dn:1;	  /* When set, powers down the
-			 main PLL. The alternate clock bit should be set to
-			 select an alternate clock before setting this bit.*/
-		uint32_t	reserved0:5;	  /* Reserved */
-		uint32_t	pll_mult:8;	  /* This setting controls
-						 the multiplier for the PLL. */
-		uint32_t	pll_div:4;	  /* This setting controls
-						 the divider for the PLL. */
-		uint32_t	reserved1:12;	  /* Reserved */
-	};
-
-	uint32_t	whole_reg;
-
-};
+#define TX_WRAP_THRESHOLD 128 * 1024
 
-union link_misc_perst_decoder_ctrl {
-	struct {
-		uint32_t	bcm_7412_rst:1; /* 1 -> BCM7412 is held
-						 in reset. Reset value 1.*/
-		uint32_t	res0:3; /* Reserved.No Effect*/
-		uint32_t	stop_7412_clk:1; /* 1 ->Stops branch of 27MHz
-						 clk used to clk BCM7412*/
-		uint32_t	res1:27; /* Reseved. No Effect */
-	};
+#define	NUMBER_OF_TRANSFERS_TX_SIDE				1
+#define NUMBER_OF_TRANSFERS_RX_SIDE				2
 
-	uint32_t	whole_reg;
+/* forward declare */
 
+struct BC_DRV_PIC_INFO {
+	struct c011_pib			DecoPIB;
+	struct BC_DRV_PIC_INFO		*Flink;
 };
 
 union desc_low_addr_reg {
 	struct {
+#ifdef	__LITTLE_ENDIAN_BITFIELD
 		uint32_t	list_valid:1;
 		uint32_t	reserved:4;
 		uint32_t	low_addr:27;
+#else
+		uint32_t	low_addr:27;
+		uint32_t	reserved:4;
+		uint32_t	list_valid:1;
+#endif
 	};
 
 	uint32_t	whole_reg;
@@ -195,6 +73,7 @@ union desc_low_addr_reg {
 };
 
 struct dma_descriptor {	/* 8 32-bit values */
+#ifdef	__LITTLE_ENDIAN_BITFIELD
 	/* 0th u32 */
 	uint32_t sdram_buff_addr:28;	/* bits 0-27:  SDRAM Address */
 	uint32_t res0:4;		/* bits 28-31: Reserved */
@@ -225,7 +104,38 @@ struct dma_descriptor {	/* 8 32-bit values */
 
 	/* 7th u32 */
 	uint32_t res8;			/* Last 32bits reserved */
+#else
+	/* 0th u32 */
+	uint32_t res0:4;		/* bits 28-31: Reserved */
+	uint32_t sdram_buff_addr:28;	/* bits 0-27:  SDRAM Address */
+
+	/* 1st u32 */
+	uint32_t buff_addr_low;		/* 1 buffer address low */
+	uint32_t buff_addr_high;	/* 2 buffer address high */
 
+	/* 3rd u32 */
+	uint32_t intr_enable:1;		/* 31 - Interrupt After this desc */
+	uint32_t res3:6;		/* 25-30 reserved */
+	uint32_t xfer_size:23;		/* 2-24 = Xfer size in words */
+	uint32_t res2:2;		/* 0-1 - Reserved */
+
+	/* 4th u32 */
+	uint32_t last_rec_indicator:1;	/* 31 bit Last Record Indicator */
+	uint32_t dma_dir:1;		/* 30 bit DMA Direction */
+	uint32_t fill_bytes:2;		/* 28-29 Bits Fill Bytes */
+	uint32_t res4:25;		/* 3 - 27 Reserved bits */
+	uint32_t next_desc_cont:1;	/* 2 - Next desc is in contig memory */
+	uint32_t endian_xlat_align:2;	/* 0-1 Endian Translation */
+
+	/* 5th u32 */
+	uint32_t next_desc_addr_low;	/* 32-bits Next Desc Addr lower */
+
+	/* 6th u32 */
+	uint32_t next_desc_addr_high;	/* 32-bits Next Desc Addr Higher */
+
+	/* 7th u32 */
+	uint32_t res8;			/* Last 32bits reserved */
+#endif
 };
 
 /*
@@ -234,17 +144,15 @@ struct dma_descriptor {	/* 8 32-bit values */
  * The  virtual address will determine what should be freed.
  */
 struct dma_desc_mem {
-	struct dma_descriptor	*pdma_desc_start; /* 32-bytes for dma
-				 descriptor. should be first element */
-	dma_addr_t		phy_addr;	/* physical address
-						 of each DMA desc */
+	struct dma_descriptor		*pdma_desc_start;	/* 32-bytes for dma descriptor. should be first element */
+	dma_addr_t		phy_addr;		/* physical address of each DMA desc */
 	uint32_t		sz;
-	struct _dma_desc_mem_	*Next; /* points to Next Descriptor in chain */
+	struct dma_desc_mem	*Next;			/* points to Next Descriptor in chain */
 
 };
 
 enum list_sts {
-	sts_free = 0,
+	sts_free		= 0,
 
 	/* RX-Y Bits 0:7 */
 	rx_waiting_y_intr	= 0x00000001,
@@ -259,27 +167,84 @@ enum list_sts {
 
 	rx_y_mask		= 0x000000FF,
 	rx_uv_mask		= 0x0000FF00,
+
+};
+
+
+enum INTERRUPT_STATUS {
+	NO_INTERRUPT					= 0x0000,
+	FPGA_RX_L0_DMA_DONE				= 0x0001, /*DONT CHANGE VALUES...SOME BITWIZE OPERATIONS WILL FAIL*/
+	FPGA_RX_L1_DMA_DONE				= 0x0002, /*DONT CHANGE VALUES...SOME BITWIZE OPERATIONS WILL FAIL*/
+	FPGA_TX_L0_DMA_DONE				= 0x0004, /*DONT CHANGE VALUES...SOME BITWIZE OPERATIONS WILL FAIL*/
+	FPGA_TX_L1_DMA_DONE				= 0x0008, /*DONT CHANGE VALUES...SOME BITWIZE OPERATIONS WILL FAIL*/
+	DECO_PIB_INTR					= 0x0010, /*DONT CHANGE VALUES...SOME BITWIZE OPERATIONS WILL FAIL*/
+	DECO_FMT_CHANGE					= 0x0020,
+	DECO_MBOX_RESP					= 0x0040,
+	DECO_RESUME_FRM_INTER_PAUSE		= 0x0080, /*Not Handled in DPC Need to Fire Rx cmds on resume from Pause*/
+};
+
+enum ERROR_STATUS {
+	NO_ERROR			=0,
+	RX_Y_DMA_ERR_L0		=0x0001,/*DONT CHANGE VALUES...SOME BITWIZE OPERATIONS WILL FAIL*/
+	RX_UV_DMA_ERR_L0	=0x0002,/*DONT CHANGE VALUES...SOME BITWIZE OPERATIONS WILL FAIL*/
+	RX_Y_DMA_ERR_L1		=0x0004,/*DONT CHANGE VALUES...SOME BITWIZE OPERATIONS WILL FAIL*/
+	RX_UV_DMA_ERR_L1	=0x0008,/*DONT CHANGE VALUES...SOME BITWIZE OPERATIONS WILL FAIL*/
+	TX_DMA_ERR_L0		=0x0010,/*DONT CHANGE VALUES...SOME BITWIZE OPERATIONS WILL FAIL*/
+	TX_DMA_ERR_L1		=0x0020,/*DONT CHANGE VALUES...SOME BITWIZE OPERATIONS WILL FAIL*/
+	FW_CMD_ERROR		=0x0040,
+	DROP_REPEATED		=0x0080,
+	DROP_FLEA_FMTCH		=0x0100,/*We do not want to deliver the flea dummy frame*/
+	DROP_DATA_ERROR		=0x0200,/*We were not able to get the PIB correctly so drop the frame. */
+	DROP_SIZE_ERROR		=0x0400,/*We were not able to get the size properly from hardware. */
+	FORCE_CANCEL		=0x8000
+};
+
+enum LIST_STATUS {
+	ListStsFree=0,				/* Initial state and state the buffer is moved to Ready Buffer list. */
+	RxListWaitingForYIntr=1,	/* When the Y Descriptor is posted. */
+	RxListWaitingForUVIntr=2,	/* When the UV descriptor is posted. */
+	TxListWaitingForIntr =4,
+};
+
+struct RX_DMA_LIST {
+	enum LIST_STATUS		ListSts;
+	/*LIST_ENTRY		ActiveList; */
+	uint32_t			ActiveListLen;
+	uint32_t			ListLockInd;					/* To Be Filled up During Init */
+	uint32_t			ulDiscCount;					/* Discontinuity On this list */
+	uint32_t			RxYFirstDescLADDRReg;			/* First Desc Low Addr Y	*/
+	uint32_t			RxYFirstDescUADDRReg;			/* First Desc UPPER Addr Y	*/
+	uint32_t			RxYCurDescLADDRReg;				/* Current Desc Low Addr Y	*/
+	uint32_t			RxYCurDescUADDRReg;				/* First Desc Low Addr Y	*/
+	uint32_t			RxYCurByteCntRemReg;			/* Cur Byte Cnt Rem Y		*/
+
+	uint32_t			RxUVFirstDescLADDRReg;			/* First Desc Low Addr UV		*/
+	uint32_t			RxUVFirstDescUADDRReg;			/* First Desc UPPER Addr UV		*/
+	uint32_t			RxUVCurDescLADDRReg;			/* Current Desc Low Addr UV		*/
+	uint32_t			RxUVCurDescUADDRReg;			/* Current Desc UPPER Addr UV	*/
+	uint32_t			RxUVCurByteCntRemReg;			/* Cur Byte Cnt Rem UV			*/
 };
 
 struct tx_dma_pkt {
-	struct dma_desc_mem	desc_mem;
+	struct dma_desc_mem		desc_mem;
 	hw_comp_callback	call_back;
 	struct crystalhd_dio_req	*dio_req;
 	wait_queue_head_t	*cb_event;
 	uint32_t		list_tag;
+
 };
 
 struct crystalhd_rx_dma_pkt {
-	struct dma_desc_mem		desc_mem;
-	struct crystalhd_dio_req	*dio_req;
+	struct dma_desc_mem			desc_mem;
+	struct crystalhd_dio_req		*dio_req;
 	uint32_t			pkt_tag;
 	uint32_t			flags;
-	struct BC_PIC_INFO_BLOCK	pib;
+	struct BC_PIC_INFO_BLOCK		pib;
 	dma_addr_t			uv_phy_addr;
-	struct crystalhd_rx_dma_pkt	*next;
+	struct  crystalhd_rx_dma_pkt	*next;
 };
 
-struct crystalhd_hw_stats {
+struct crystalhd_hw_stats{
 	uint32_t	rx_errors;
 	uint32_t	tx_errors;
 	uint32_t	freeq_count;
@@ -288,29 +253,106 @@ struct crystalhd_hw_stats {
 	uint32_t	dev_interrupts;
 	uint32_t	cin_busy;
 	uint32_t	pause_cnt;
+	uint32_t	rx_success;
+};
+
+enum DECO_STATE {
+	DECO_OPERATIONAL				= 0,			/* We start with this state.ST_FW_DWNLD,ST_CAPTURE,STOP_CAPTURE */
+	DECO_INTER_PAUSED				= 1,			/* Driver Issued Pause To Decoder */
+	DECO_INTER_PAUSE_IN_PROGRESS	= 2,			/* Pause CMD is pending with F/W  */
+	DECO_INTER_RESUME_IN_PROGRESS	= 3,			/* Resume CMD is pending with F/W */
+	DECO_STOPPED_BY_APP				= 4				/* After STOP Video I do not want to Throttle Decoder.So Special State */
 };
 
+/* */
+/* These events can be used to notify the hardware layer */
+/* to set up it adapter in proper state...or for anyother */
+/* purpose for that matter. */
+/* We will use this for intermediae events as defined below */
+
+enum BRCM_EVENT {
+	BC_EVENT_ADAPTER_INIT_FAILED	=0,
+	BC_EVENT_ADAPTER_INIT_SUCCESS	=1,
+	BC_EVENT_FW_DNLD_STARTED		=2,
+	BC_EVENT_FW_DNLD_ERR			=3,
+	BC_EVENT_FW_DNLD_DONE			=4,
+	BC_EVENT_SYS_SHUT_DOWN			=5,
+	BC_EVENT_START_CAPTURE			=6,
+	BC_EVENT_START_CAPTURE_IMMI		=7,
+	BC_EVENT_STOP_CAPTURE			=8,		/* Stop Capturing the Rx buffers Stop the DMA engines UnMapBuffers Discard Free and Ready list */
+	BC_EVENT_DO_CLEANUP				=9,		/* Total Cleanup Rx And Tx side */
+	BC_DISCARD_RX_BUFFERS			=10		/* Move all the Ready buffers to free list. Stop RX DMA. Post Rx Side buffers. */
+};
+
+struct crystalhd_hw; /* forward declaration for the types */
+
+/*typedef void*		(*HW_VERIFY_DEVICE)(struct crystalhd_adp*); */
+/*typedef bool		(*HW_INIT_DEVICE_RESOURCES)(struct crystalhd_adp*); */
+/*typedef bool		(*HW_CLEAN_DEVICE_RESOURCES)(struct crystalhd_adp*); */
+typedef bool		(*HW_START_DEVICE)(struct crystalhd_hw*);
+typedef bool		(*HW_STOP_DEVICE)(struct crystalhd_hw*);
+/* typedef bool	(*HW_XLAT_AND_FIRE_SGL)(struct crystalhd_adp*,PVOID,PSCATTER_GATHER_LIST,uint32_t); */
+/* typedef bool	(*HW_RX_XLAT_SGL)(struct crystalhd_adp*,crystalhd_dio_req *ioreq); */
+typedef bool		(*HW_FIND_AND_CLEAR_INTR)(struct crystalhd_adp*,struct crystalhd_hw*);
+typedef uint32_t	(*HW_READ_DEVICE_REG)(struct crystalhd_adp*,uint32_t);
+typedef void		(*HW_WRITE_DEVICE_REG)(struct crystalhd_adp*,uint32_t,uint32_t);
+typedef uint32_t	(*HW_READ_FPGA_REG)(struct crystalhd_adp*,uint32_t);
+typedef void		(*HW_WRITE_FPGA_REG)(struct crystalhd_adp*,uint32_t,uint32_t);
+typedef enum BC_STATUS	(*HW_READ_DEV_MEM)(struct crystalhd_hw*,uint32_t,uint32_t,uint32_t*);
+typedef enum BC_STATUS	(*HW_WRITE_DEV_MEM)(struct crystalhd_hw*,uint32_t,uint32_t,uint32_t*);
+/* typedef bool		(*HW_INIT_DRAM)(struct crystalhd_adp*); */
+/* typedef bool		(*HW_DISABLE_INTR)(struct crystalhd_adp*); */
+/* typedef bool		(*HW_ENABLE_INTR)(struct crystalhd_adp*); */
+typedef enum BC_STATUS	(*HW_POST_RX_SIDE_BUFF)(struct crystalhd_hw*,struct crystalhd_rx_dma_pkt*);
+typedef bool		(*HW_CHECK_INPUT_FIFO)(struct crystalhd_hw*, uint32_t, uint32_t*,bool,uint8_t*);
+typedef void		(*HW_START_TX_DMA)(struct crystalhd_hw*, uint8_t, addr_64);
+typedef enum BC_STATUS	(*HW_STOP_TX_DMA)(struct crystalhd_hw*);
+/* typedef bool		(*HW_EVENT_NOTIFICATION)(struct crystalhd_adp*,BRCM_EVENT); */
+/* typedef bool		(*HW_RX_POST_INTR_PROCESSING)(struct crystalhd_adp*,uint32_t,uint32_t); */
+typedef void		(*HW_GET_DONE_SIZE)(struct crystalhd_hw *hw, uint32_t, uint32_t*, uint32_t*);
+/* typedef bool		(*HW_ADD_DRP_TO_FREE_LIST)(struct crystalhd_adp*,crystalhd_dio_req *ioreq); */
+typedef struct crystalhd_dio_req*	(*HW_FETCH_DONE_BUFFERS)(struct crystalhd_adp*,bool);
+/* typedef bool		(*HW_ADD_ROLLBACK_RXBUF)(struct crystalhd_adp*,crystalhd_dio_req *ioreq); */
+typedef bool		(*HW_PEEK_NEXT_DECODED_RXBUF)(struct crystalhd_hw*,uint64_t*,uint32_t*,uint32_t);
+typedef enum BC_STATUS	(*HW_FW_PASSTHRU_CMD)(struct crystalhd_hw*,struct BC_FW_CMD*);
+/* typedef bool		(*HW_CANCEL_FW_CMDS)(struct crystalhd_adp*,OS_CANCEL_CALLBACK); */
+/* typedef void*	(*HW_GET_FW_DONE_OS_CMD)(struct crystalhd_adp*); */
+/* typedef PBC_DRV_PIC_INFO	(*SEARCH_FOR_PIB)(struct crystalhd_adp*,bool,uint32_t); */
+/* typedef bool		(*HW_DO_DRAM_PWR_MGMT)(struct crystalhd_adp*); */
+typedef enum BC_STATUS	(*HW_FW_DOWNLOAD)(struct crystalhd_hw*,uint8_t*,uint32_t);
+typedef enum BC_STATUS	(*HW_ISSUE_DECO_PAUSE)(struct crystalhd_hw*, bool);
+typedef void		(*HW_STOP_DMA_ENGINES)(struct crystalhd_hw*);
+/*
+typedef BOOLEAN		(*FIRE_RX_REQ_TO_HW)	(PHW_EXTENSION,PRX_DMA_LIST);
+typedef BOOLEAN		(*PIC_POST_PROC)	(PHW_EXTENSION,PRX_DMA_LIST,PULONG);
+typedef BOOLEAN		(*HW_ISSUE_DECO_PAUSE)	(PHW_EXTENSION,BOOLEAN,BOOLEAN);
+typedef BOOLEAN		(*FIRE_TX_CMD_TO_HW)	(PCONTEXT_FOR_POST_TX);
+*/
+typedef void		(*NOTIFY_FLL_CHANGE)(struct crystalhd_hw*,bool);
+typedef bool		(*HW_EVENT_NOTIFICATION)(struct crystalhd_hw*, enum BRCM_EVENT);
+
 struct crystalhd_hw {
-	struct tx_dma_pkt	tx_pkt_pool[DMA_ENGINE_CNT];
+	struct tx_dma_pkt		tx_pkt_pool[DMA_ENGINE_CNT];
 	spinlock_t		lock;
 
 	uint32_t		tx_ioq_tag_seed;
 	uint32_t		tx_list_post_index;
 
-	struct crystalhd_rx_dma_pkt *rx_pkt_pool_head;
+	struct crystalhd_rx_dma_pkt	*rx_pkt_pool_head;
 	uint32_t		rx_pkt_tag_seed;
 
 	bool			dev_started;
-	void			*adp;
+	struct crystalhd_adp	*adp;
 
 	wait_queue_head_t	*pfw_cmd_event;
 	int			fwcmd_evt_sts;
 
 	uint32_t		pib_del_Q_addr;
 	uint32_t		pib_rel_Q_addr;
+	uint32_t		channelNum;
 
-	struct crystalhd_dioq	*tx_freeq;
-	struct crystalhd_dioq	*tx_actq;
+	struct crystalhd_dioq		*tx_freeq;
+	struct crystalhd_dioq		*tx_actq;
 
 	/* Rx DMA Engine Specific Locks */
 	spinlock_t		rx_lock;
@@ -321,87 +363,192 @@ struct crystalhd_hw {
 	struct crystalhd_dioq	*rx_actq;
 	uint32_t		stop_pending;
 
+	uint32_t		hw_pause_issued;
+
+	uint32_t		fwcmdPostAddr;
+	uint32_t		fwcmdPostMbox;
+	uint32_t		fwcmdRespMbox;
+
 	/* HW counters.. */
 	struct crystalhd_hw_stats	stats;
 
-	/* Core clock in MHz */
-	uint32_t		core_clock_mhz;
-	uint32_t		prev_n;
-	uint32_t		pwr_lock;
+	/* Picture Information Block Management Variables */
+	uint32_t	PICWidth;	/* Pic Width Recieved On Format Change for link/With WidthField On Flea*/
+	uint32_t	PICHeight;	/* Pic Height Recieved on format change[Link and Flea]/Not Used in Flea*/
+	uint32_t	LastPicNo;	/* For Repeated Frame Detection */
+	uint32_t	LastTwoPicNo;	/* For Repeated Frame Detection on Interlace clip*/
+	uint32_t	LastSessNum;	/* For Session Change Detection */
+
+	struct semaphore fetch_sem; /* semaphore between fetch and probe of the next picture information, since both will be in process context */
+
+	uint32_t	RxCaptureState; /* 0 if capture is not enabled, 1 if capture is enabled, 2 if stop rxdma is pending */
+
+	/* BCM70015 mods */
+	uint32_t	PicQSts;		/* This is the bitmap given by PiCQSts Interrupt*/
+	uint32_t	TxBuffInfoAddr;		/* Address of the TX Fifo in DRAM*/
+	uint32_t	FleaRxPicDelAddr;	/* Memory address where the pictures are fired*/
+	uint32_t	FleaFLLUpdateAddr;	/* Memory Address where FLL is updated*/
+	uint32_t	FleaBmpIntrCnt;
+	uint32_t	RxSeqNum;
+	uint32_t	DrvEosDetected;
+	uint32_t	DrvCancelEosFlag;
+
+	uint32_t	SkipDropBadFrames;
+	uint32_t	TemperatureRegVal;
+	struct TX_INPUT_BUFFER_INFO	TxFwInputBuffInfo;
+
+	enum DECO_STATE			DecoderSt;				/* Weather the decoder is paused or not*/
+	uint32_t			PauseThreshold;
+	uint32_t			ResumeThreshold;
+
+	uint32_t				RxListPointer;					/* Treat the Rx List As Circular List */
+	enum LIST_STATUS				TxList0Sts;
+	enum LIST_STATUS				TxList1Sts;
+
+	uint32_t			FleaEnablePWM;
+	uint32_t			FleaWaitFirstPlaybackNotify;
+	enum FLEA_POWER_STATES	FleaPowerState;
+	uint32_t			EmptyCnt;
+	bool				SingleThreadAppFIFOEmpty;
+	bool				PwrDwnTxIntr; /* Got an TX FIFO status interrupt when in power down state */
+	bool				PwrDwnPiQIntr; /* Got a Picture Q interrupt when in power down state */
+	uint32_t			OLWatchDogTimer;
+	uint32_t			ILWatchDogTimer;
+	uint32_t			FwCmdCnt;
+	bool				WakeUpDecodeDone; /* Used to indicate that the HW is awake to RX is running so we can actively manage power */
+
+	uint64_t			TickCntDecodePU; /* Time when we first powered up to decode */
+	uint64_t			TickSpentInPD; /* Total amount of time spent in PD */
+	uint64_t			TickStartInPD; /* Tick count when we start in PD */
+	uint32_t			PDRatio; /* % of time spent in power down. Goal is to keep this close to 50 */
+	uint32_t			DefaultPauseThreshold; /* default threshold to set when we start power management */
+
+/*	uint32_t			FreeListLen; */
+/*	uint32_t			ReadyListLen; */
+
+/* */
+/*	Counters needed for monitoring purposes. */
+/*	These counters are per session and will be reset to zero in */
+/*  start capture. */
+/* */
+	uint32_t					DrvPauseCnt;					 /* Number of Times the driver has issued pause.*/
+#if 0
+	uint32_t					DrvServiceIntrCnt;				 /* Number of interrutps the driver serviced. */
+	uint32_t					DrvIgnIntrCnt;					 /* Number of Interrupts Driver Ignored.NOT OUR INTR. */
+	uint32_t					DrvTotalFrmDropped;				 /* Number of frames dropped by the driver.*/
+#endif
+	uint32_t					DrvTotalFrmCaptured;			 /* Numner of Good Frames Captured*/
+#if 0
+	uint32_t					DrvTotalHWErrs;					 /* Total HW Errors.*/
+	uint32_t					DrvTotalPIBFlushCnt;			 /* Number of Times the driver flushed PIB Queues.*/
+	uint32_t					DrvMissedPIBCnt;				 /* Number of Frames for which the PIB was not found.*/
+	uint64_t					TickCntOnPause; */
+	uint32_t					TotalTimeInPause;				/* In Milliseconds */
+	uint32_t					RepeatedFramesCnt; */
+#endif
+
+/*	HW_VERIFY_DEVICE			pfnVerifyDevice; */
+/*	HW_INIT_DEVICE_RESOURCES		pfnInitDevResources; */
+/*	HW_CLEAN_DEVICE_RESOURCES		pfnCleanDevResources; */
+	HW_START_DEVICE				pfnStartDevice;
+	HW_STOP_DEVICE				pfnStopDevice;
+/*	HW_XLAT_AND_FIRE_SGL			pfnTxXlatAndFireSGL; */
+/*	HW_RX_XLAT_SGL				pfnRxXlatSgl; */
+	HW_FIND_AND_CLEAR_INTR		pfnFindAndClearIntr;
+	HW_READ_DEVICE_REG			pfnReadDevRegister;
+	HW_WRITE_DEVICE_REG			pfnWriteDevRegister;
+	HW_READ_FPGA_REG			pfnReadFPGARegister;
+	HW_WRITE_FPGA_REG			pfnWriteFPGARegister;
+	HW_READ_DEV_MEM				pfnDevDRAMRead;
+	HW_WRITE_DEV_MEM			pfnDevDRAMWrite;
+/*	HW_INIT_DRAM				pfnInitDRAM; */
+/*	HW_DISABLE_INTR				pfnDisableIntr; */
+/*	HW_ENABLE_INTR				pfnEnableIntr; */
+	HW_POST_RX_SIDE_BUFF			pfnPostRxSideBuff;
+	HW_CHECK_INPUT_FIFO			pfnCheckInputFIFO;
+	HW_START_TX_DMA				pfnStartTxDMA;
+	HW_STOP_TX_DMA				pfnStopTxDMA;
+	HW_GET_DONE_SIZE			pfnHWGetDoneSize;
+/*	HW_EVENT_NOTIFICATION			pfnNotifyHardware; */
+/*	HW_ADD_DRP_TO_FREE_LIST			pfnAddRxDRPToFreeList; */
+/*	HW_FETCH_DONE_BUFFERS			pfnFetchReadyRxDRP; */
+/*	HW_ADD_ROLLBACK_RXBUF			pfnRollBackRxBuf; */
+	HW_PEEK_NEXT_DECODED_RXBUF		pfnPeekNextDeodedFr;
+	HW_FW_PASSTHRU_CMD			pfnDoFirmwareCmd;
+/*	HW_GET_FW_DONE_OS_CMD			pfnGetFWDoneCmdOsCntxt; */
+/*	HW_CANCEL_FW_CMDS			pfnCancelFWCmds; */
+/*	SEARCH_FOR_PIB				pfnSearchPIB; */
+/*	HW_DO_DRAM_PWR_MGMT			pfnDRAMPwrMgmt; */
+	HW_FW_DOWNLOAD				pfnFWDwnld;
+	HW_ISSUE_DECO_PAUSE			pfnIssuePause;
+	HW_STOP_DMA_ENGINES			pfnStopRXDMAEngines;
+/*	FIRE_RX_REQ_TO_HW			pfnFireRx; */
+/*	PIC_POST_PROC				pfnPostProcessPicture; */
+/*	FIRE_TX_CMD_TO_HW			pfnFireTx; */
+	NOTIFY_FLL_CHANGE			pfnNotifyFLLChange;
+	HW_EVENT_NOTIFICATION		pfnNotifyHardware;
 };
 
-/* Clock defines for power control */
-#define CLOCK_PRESET 175
-
-/* DMA engine register BIT mask wrappers.. */
-#define DMA_START_BIT	MISC1_TX_SW_DESC_LIST_CTRL_STS_TX_DMA_RUN_STOP_MASK
-
-#define GET_RX_INTR_MASK (INTR_INTR_STATUS_L1_UV_RX_DMA_ERR_INTR_MASK |	\
-	INTR_INTR_STATUS_L1_UV_RX_DMA_DONE_INTR_MASK |	\
-	INTR_INTR_STATUS_L1_Y_RX_DMA_ERR_INTR_MASK |		\
-	INTR_INTR_STATUS_L1_Y_RX_DMA_DONE_INTR_MASK |		\
-	INTR_INTR_STATUS_L0_UV_RX_DMA_ERR_INTR_MASK |		\
-	INTR_INTR_STATUS_L0_UV_RX_DMA_DONE_INTR_MASK |	\
-	INTR_INTR_STATUS_L0_Y_RX_DMA_ERR_INTR_MASK |		\
-	INTR_INTR_STATUS_L0_Y_RX_DMA_DONE_INTR_MASK)
-
-#define GET_Y0_ERR_MSK (MISC1_Y_RX_ERROR_STATUS_RX_L0_OVERRUN_ERROR_MASK | \
-	MISC1_Y_RX_ERROR_STATUS_RX_L0_UNDERRUN_ERROR_MASK |		\
-	MISC1_Y_RX_ERROR_STATUS_RX_L0_DESC_TX_ABORT_ERRORS_MASK |	\
-	MISC1_Y_RX_ERROR_STATUS_RX_L0_FIFO_FULL_ERRORS_MASK)
-
-#define GET_UV0_ERR_MSK (MISC1_UV_RX_ERROR_STATUS_RX_L0_OVERRUN_ERROR_MASK | \
-	MISC1_UV_RX_ERROR_STATUS_RX_L0_UNDERRUN_ERROR_MASK |		\
-	MISC1_UV_RX_ERROR_STATUS_RX_L0_DESC_TX_ABORT_ERRORS_MASK |	\
-	MISC1_UV_RX_ERROR_STATUS_RX_L0_FIFO_FULL_ERRORS_MASK)
-
-#define GET_Y1_ERR_MSK (MISC1_Y_RX_ERROR_STATUS_RX_L1_OVERRUN_ERROR_MASK | \
-	MISC1_Y_RX_ERROR_STATUS_RX_L1_UNDERRUN_ERROR_MASK |		\
-	MISC1_Y_RX_ERROR_STATUS_RX_L1_DESC_TX_ABORT_ERRORS_MASK |	\
-	MISC1_Y_RX_ERROR_STATUS_RX_L1_FIFO_FULL_ERRORS_MASK)
-
-#define GET_UV1_ERR_MSK	(MISC1_UV_RX_ERROR_STATUS_RX_L1_OVERRUN_ERROR_MASK | \
-	MISC1_UV_RX_ERROR_STATUS_RX_L1_UNDERRUN_ERROR_MASK |		\
-	MISC1_UV_RX_ERROR_STATUS_RX_L1_DESC_TX_ABORT_ERRORS_MASK |	\
-	MISC1_UV_RX_ERROR_STATUS_RX_L1_FIFO_FULL_ERRORS_MASK)
-
-
-/**** API Exposed to the other layers ****/
-enum BC_STATUS crystalhd_download_fw(struct crystalhd_adp *adp,
-			      void *buffer, uint32_t sz);
-enum BC_STATUS crystalhd_do_fw_cmd(struct crystalhd_hw *hw,
-				 struct BC_FW_CMD *fw_cmd);
-bool crystalhd_hw_interrupt(struct crystalhd_adp *adp,
-				 struct crystalhd_hw *hw);
-enum BC_STATUS crystalhd_hw_open(struct crystalhd_hw *,
-				 struct crystalhd_adp *);
-enum BC_STATUS crystalhd_hw_close(struct crystalhd_hw *);
-enum BC_STATUS crystalhd_hw_setup_dma_rings(struct crystalhd_hw *);
-enum BC_STATUS crystalhd_hw_free_dma_rings(struct crystalhd_hw *);
-
-
-enum BC_STATUS crystalhd_hw_post_tx(struct crystalhd_hw *hw,
-			     struct crystalhd_dio_req *ioreq,
-			     hw_comp_callback call_back,
-			     wait_queue_head_t *cb_event,
-			     uint32_t *list_id, uint8_t data_flags);
-
-enum BC_STATUS crystalhd_hw_pause(struct crystalhd_hw *hw);
-enum BC_STATUS crystalhd_hw_unpause(struct crystalhd_hw *hw);
-enum BC_STATUS crystalhd_hw_suspend(struct crystalhd_hw *hw);
+struct crystalhd_rx_dma_pkt *crystalhd_hw_alloc_rx_pkt(struct crystalhd_hw *hw);
+void crystalhd_hw_free_rx_pkt(struct crystalhd_hw *hw, struct crystalhd_rx_dma_pkt *pkt);
+void crystalhd_tx_desc_rel_call_back(void *context, void *data);
+void crystalhd_rx_pkt_rel_call_back(void *context, void *data);
+void crystalhd_hw_delete_ioqs(struct crystalhd_hw *hw);
+enum BC_STATUS crystalhd_hw_create_ioqs(struct crystalhd_hw *hw);
+enum BC_STATUS crystalhd_hw_open(struct crystalhd_hw *hw, struct crystalhd_adp *adp);
+enum BC_STATUS crystalhd_hw_close(struct crystalhd_hw *hw, struct crystalhd_adp *adp);
+enum BC_STATUS crystalhd_hw_setup_dma_rings(struct crystalhd_hw *hw);
+enum BC_STATUS crystalhd_hw_free_dma_rings(struct crystalhd_hw *hw);
+enum BC_STATUS crystalhd_hw_tx_req_complete(struct crystalhd_hw *hw, uint32_t list_id, enum BC_STATUS cs);
+enum BC_STATUS crystalhd_hw_fill_desc(struct crystalhd_dio_req *ioreq,
+				struct dma_descriptor *desc,
+				dma_addr_t desc_paddr_base,
+				uint32_t sg_cnt, uint32_t sg_st_ix,
+				uint32_t sg_st_off, uint32_t xfr_sz,
+				struct device *dev, uint32_t destDRAMaddr);
+enum BC_STATUS crystalhd_xlat_sgl_to_dma_desc(struct crystalhd_dio_req *ioreq,
+					struct dma_desc_mem * pdesc_mem,
+					uint32_t *uv_desc_index,
+					struct device *dev, uint32_t destDRAMaddr);
+enum BC_STATUS crystalhd_rx_pkt_done(struct crystalhd_hw *hw,
+				uint32_t list_index,
+				enum BC_STATUS comp_sts);
+enum BC_STATUS crystalhd_hw_post_tx(struct crystalhd_hw *hw, struct crystalhd_dio_req *ioreq,
+				hw_comp_callback call_back,
+				wait_queue_head_t *cb_event, uint32_t *list_id,
+				uint8_t data_flags);
 enum BC_STATUS crystalhd_hw_cancel_tx(struct crystalhd_hw *hw,
 				 uint32_t list_id);
 enum BC_STATUS crystalhd_hw_add_cap_buffer(struct crystalhd_hw *hw,
 			 struct crystalhd_dio_req *ioreq, bool en_post);
 enum BC_STATUS crystalhd_hw_get_cap_buffer(struct crystalhd_hw *hw,
-				    struct BC_PIC_INFO_BLOCK *pib,
+				    struct c011_pib *pib,
 				    struct crystalhd_dio_req **ioreq);
-enum BC_STATUS crystalhd_hw_stop_capture(struct crystalhd_hw *hw);
 enum BC_STATUS crystalhd_hw_start_capture(struct crystalhd_hw *hw);
+enum BC_STATUS crystalhd_hw_stop_capture(struct crystalhd_hw *hw, bool unmap);
+enum BC_STATUS crystalhd_hw_suspend(struct crystalhd_hw *hw);
+enum BC_STATUS crystalhd_hw_resume(struct crystalhd_hw *hw);
 void crystalhd_hw_stats(struct crystalhd_hw *hw,
 			 struct crystalhd_hw_stats *stats);
 
-/* API to program the core clock on the decoder */
-enum BC_STATUS crystalhd_hw_set_core_clock(struct crystalhd_hw *);
+#define GET_Y0_ERR_MSK (MISC1_Y_RX_ERROR_STATUS_RX_L0_OVERRUN_ERROR_MASK |		\
+						MISC1_Y_RX_ERROR_STATUS_RX_L0_UNDERRUN_ERROR_MASK |		\
+						MISC1_Y_RX_ERROR_STATUS_RX_L0_DESC_TX_ABORT_ERRORS_MASK |	\
+						MISC1_Y_RX_ERROR_STATUS_RX_L0_FIFO_FULL_ERRORS_MASK)
+
+#define GET_UV0_ERR_MSK (MISC1_UV_RX_ERROR_STATUS_RX_L0_OVERRUN_ERROR_MASK |		\
+						MISC1_UV_RX_ERROR_STATUS_RX_L0_UNDERRUN_ERROR_MASK |		\
+						MISC1_UV_RX_ERROR_STATUS_RX_L0_DESC_TX_ABORT_ERRORS_MASK |	\
+						MISC1_UV_RX_ERROR_STATUS_RX_L0_FIFO_FULL_ERRORS_MASK)
+
+#define GET_Y1_ERR_MSK (MISC1_Y_RX_ERROR_STATUS_RX_L1_OVERRUN_ERROR_MASK |		\
+						MISC1_Y_RX_ERROR_STATUS_RX_L1_UNDERRUN_ERROR_MASK |		\
+						MISC1_Y_RX_ERROR_STATUS_RX_L1_DESC_TX_ABORT_ERRORS_MASK |	\
+						MISC1_Y_RX_ERROR_STATUS_RX_L1_FIFO_FULL_ERRORS_MASK)
+
+#define GET_UV1_ERR_MSK	(MISC1_UV_RX_ERROR_STATUS_RX_L1_OVERRUN_ERROR_MASK |		\
+						MISC1_UV_RX_ERROR_STATUS_RX_L1_UNDERRUN_ERROR_MASK |		\
+						MISC1_UV_RX_ERROR_STATUS_RX_L1_DESC_TX_ABORT_ERRORS_MASK |	\
+						MISC1_UV_RX_ERROR_STATUS_RX_L1_FIFO_FULL_ERRORS_MASK)
 
 #endif
diff --git a/drivers/staging/crystalhd/crystalhd_linkfuncs.c b/drivers/staging/crystalhd/crystalhd_linkfuncs.c
new file mode 100644
index 0000000..f677e5d
--- /dev/null
+++ b/drivers/staging/crystalhd/crystalhd_linkfuncs.c
@@ -0,0 +1,2057 @@
+/***************************************************************************
+ * Copyright (c) 2005-2009, Broadcom Corporation.
+ *
+ *  Name: crystalhd_hw . c
+ *
+ *  Description:
+ *		BCM70010 Linux driver HW layer.
+ *
+ **********************************************************************
+ * This file is part of the crystalhd device driver.
+ *
+ * This driver is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * This driver is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this driver.  If not, see <http://www.gnu.org/licenses/>.
+ **********************************************************************/
+
+#include "crystalhd.h"
+
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <asm/tsc.h>
+
+#define OFFSETOF(_s_, _m_) ((size_t)(unsigned long)&(((_s_ *)0)->_m_))
+
+/**
+* link_dec_reg_rd - Read 70010's device register.
+* @adp: Adapter instance
+* @reg_off: Register offset.
+*
+* Return:
+*	32bit value read
+*
+* 70010's device register read routine. This interface use
+* 70010's device access range mapped from BAR-2 (4M) of PCIe
+* configuration space.
+*/
+uint32_t link_dec_reg_rd(struct crystalhd_adp *adp, uint32_t reg_off)
+{
+	if (!adp) {
+		printk(KERN_ERR "%s: Invalid args\n", __func__);
+		return 0;
+	}
+
+	if (reg_off > adp->pci_mem_len) {
+		dev_err(&adp->pdev->dev, "%s: reg_off out of range: 0x%08x\n",
+			__func__, reg_off);
+		return 0;
+	}
+
+	return readl(adp->mem_addr + reg_off);
+}
+
+/**
+* link_dec_reg_wr - Write 70010's device register
+* @adp: Adapter instance
+* @reg_off: Register offset.
+* @val: Dword value to be written.
+*
+* Return:
+*	none.
+*
+* 70010's device register write routine. This interface use
+* 70010's device access range mapped from BAR-2 (4M) of PCIe
+* configuration space.
+*/
+void link_dec_reg_wr(struct crystalhd_adp *adp, uint32_t reg_off, uint32_t val)
+{
+	if (!adp) {
+		printk(KERN_ERR "%s: Invalid args\n", __func__);
+		return;
+	}
+
+	if (reg_off > adp->pci_mem_len) {
+		dev_err(&adp->pdev->dev, "%s: reg_off out of range: 0x%08x\n",
+			__func__, reg_off);
+		return;
+	}
+
+	writel(val, adp->mem_addr + reg_off);
+
+	/* the udelay is required for latest 70012, not for others... :( */
+	udelay(8);
+}
+
+/**
+* crystalhd_reg_rd - Read 70012's device register.
+* @adp: Adapter instance
+* @reg_off: Register offset.
+*
+* Return:
+*	32bit value read
+*
+* 70012 device register  read routine. This interface use
+* 70012's device access range mapped from BAR-1 (64K) of PCIe
+* configuration space.
+*
+*/
+uint32_t crystalhd_link_reg_rd(struct crystalhd_adp *adp, uint32_t reg_off)
+{
+	if (!adp) {
+		printk(KERN_ERR "%s: Invalid args\n", __func__);
+		return 0;
+	}
+
+	if (reg_off > adp->pci_i2o_len) {
+		dev_err(&adp->pdev->dev, "%s: reg_off out of range: 0x%08x\n",
+			__func__, reg_off);
+		return 0;
+	}
+
+	return readl(adp->i2o_addr + reg_off);
+}
+
+/**
+* crystalhd_reg_wr - Write 70012's device register
+* @adp: Adapter instance
+* @reg_off: Register offset.
+* @val: Dword value to be written.
+*
+* Return:
+*	none.
+*
+* 70012 device register  write routine. This interface use
+* 70012's device access range mapped from BAR-1 (64K) of PCIe
+* configuration space.
+*
+*/
+void crystalhd_link_reg_wr(struct crystalhd_adp *adp, uint32_t reg_off, uint32_t val)
+{
+	if (!adp) {
+		printk(KERN_ERR "%s: Invalid args\n", __func__);
+		return;
+	}
+
+	if (reg_off > adp->pci_i2o_len) {
+		dev_err(&adp->pdev->dev, "%s: reg_off out of range: 0x%08x\n",
+				__func__, reg_off);
+				return;
+	}
+
+	writel(val, adp->i2o_addr + reg_off);
+}
+
+inline uint32_t crystalhd_link_dram_rd(struct crystalhd_hw *hw, uint32_t mem_off)
+{
+	hw->pfnWriteFPGARegister(hw->adp,  DCI_DRAM_BASE_ADDR, (mem_off >> 19));
+	return hw->pfnReadDevRegister(hw->adp,  (0x00380000 | (mem_off & 0x0007FFFF)));
+}
+
+inline void crystalhd_link_dram_wr(struct crystalhd_hw *hw, uint32_t mem_off, uint32_t val)
+{
+	hw->pfnWriteFPGARegister(hw->adp, DCI_DRAM_BASE_ADDR, (mem_off >> 19));
+	hw->pfnWriteDevRegister(hw->adp, (0x00380000 | (mem_off & 0x0007FFFF)), val);
+}
+
+/**
+* crystalhd_link_mem_rd - Read data from DRAM area.
+* @adp: Adapter instance
+* @start_off: Start offset.
+* @dw_cnt: Count in dwords.
+* @rd_buff: Buffer to copy the data from dram.
+*
+* Return:
+*	Status.
+*
+* Dram read routine.
+*/
+enum BC_STATUS crystalhd_link_mem_rd(struct crystalhd_hw *hw, uint32_t start_off,
+								uint32_t dw_cnt, uint32_t *rd_buff)
+{
+	uint32_t ix = 0;
+
+	if (!hw || !rd_buff) {
+		printk(KERN_ERR "%s: Invalid arg\n", __func__);
+		return BC_STS_INV_ARG;
+	}
+	for (ix = 0; ix < dw_cnt; ix++)
+		rd_buff[ix] = crystalhd_link_dram_rd(hw, (start_off + (ix * 4)));
+
+	return BC_STS_SUCCESS;
+}
+
+/**
+* crystalhd_link_mem_wr - Write data to DRAM area.
+* @adp: Adapter instance
+* @start_off: Start offset.
+* @dw_cnt: Count in dwords.
+* @wr_buff: Data Buffer to be written.
+*
+* Return:
+*	Status.
+*
+* Dram write routine.
+*/
+enum BC_STATUS crystalhd_link_mem_wr(struct crystalhd_hw *hw, uint32_t start_off,
+						uint32_t dw_cnt, uint32_t *wr_buff)
+{
+	uint32_t ix = 0;
+
+	if (!hw || !wr_buff) {
+		printk(KERN_ERR "%s: Invalid arg\n", __func__);
+		return BC_STS_INV_ARG;
+	}
+
+	for (ix = 0; ix < dw_cnt; ix++)
+		crystalhd_link_dram_wr(hw, (start_off + (ix * 4)), wr_buff[ix]);
+
+	return BC_STS_SUCCESS;
+}
+
+void crystalhd_link_enable_uarts(struct crystalhd_hw *hw)
+{
+	hw->pfnWriteDevRegister(hw->adp, UartSelectA, BSVS_UART_STREAM);
+	hw->pfnWriteDevRegister(hw->adp, UartSelectB, BSVS_UART_DEC_OUTER);
+}
+
+void crystalhd_link_start_dram(struct crystalhd_hw *hw)
+{
+	hw->pfnWriteDevRegister(hw->adp, SDRAM_PARAM, ((40 / 5 - 1) <<  0) |
+#if 0
+	 tras (40ns tras)/(5ns period) -1 ((15/5 - 1) <<  4) | /* trcd */
+#endif
+		      ((15 / 5 - 1) <<  7) |	/* trp */
+		      ((10 / 5 - 1) << 10) |	/* trrd */
+		      ((15 / 5 + 1) << 12) |	/* twr */
+		      ((2 + 1) << 16) |		/* twtr */
+		      ((70 / 5 - 2) << 19) |	/* trfc */
+		      (0 << 23));
+
+	hw->pfnWriteDevRegister(hw->adp, SDRAM_PRECHARGE, 0);
+	hw->pfnWriteDevRegister(hw->adp, SDRAM_EXT_MODE, 2);
+	hw->pfnWriteDevRegister(hw->adp, SDRAM_MODE, 0x132);
+	hw->pfnWriteDevRegister(hw->adp, SDRAM_PRECHARGE, 0);
+	hw->pfnWriteDevRegister(hw->adp, SDRAM_REFRESH, 0);
+	hw->pfnWriteDevRegister(hw->adp, SDRAM_REFRESH, 0);
+	hw->pfnWriteDevRegister(hw->adp, SDRAM_MODE, 0x32);
+	/* setting the refresh rate here */
+	hw->pfnWriteDevRegister(hw->adp, SDRAM_REF_PARAM, ((1 << 12) | 96));
+}
+
+
+bool crystalhd_link_bring_out_of_rst(struct crystalhd_hw *hw)
+{
+	union link_misc_perst_deco_ctrl rst_deco_cntrl;
+	union link_misc_perst_clk_ctrl rst_clk_cntrl;
+	uint32_t temp;
+
+	/*
+	 * Link clocks: MISC_PERST_CLOCK_CTRL Clear PLL power down bit,
+	 * delay to allow PLL to lock Clear alternate clock, stop clock bits
+	 */
+	rst_clk_cntrl.whole_reg = hw->pfnReadFPGARegister(hw->adp, MISC_PERST_CLOCK_CTRL);
+	rst_clk_cntrl.pll_pwr_dn = 0;
+	hw->pfnWriteFPGARegister(hw->adp, MISC_PERST_CLOCK_CTRL, rst_clk_cntrl.whole_reg);
+	msleep_interruptible(50);
+
+	rst_clk_cntrl.whole_reg = hw->pfnReadFPGARegister(hw->adp, MISC_PERST_CLOCK_CTRL);
+	rst_clk_cntrl.stop_core_clk = 0;
+	rst_clk_cntrl.sel_alt_clk = 0;
+
+	hw->pfnWriteFPGARegister(hw->adp, MISC_PERST_CLOCK_CTRL, rst_clk_cntrl.whole_reg);
+	msleep_interruptible(50);
+
+	/*
+	 * Bus Arbiter Timeout: GISB_ARBITER_TIMER
+	 * Set internal bus arbiter timeout to 40us based on core clock speed
+	 * (63MHz * 40us = 0x9D8)
+	 */
+	hw->pfnWriteFPGARegister(hw->adp, GISB_ARBITER_TIMER, 0x9D8);
+
+	/*
+	 * Decoder clocks: MISC_PERST_DECODER_CTRL
+	 * Enable clocks while 7412 reset is asserted, delay
+	 * De-assert 7412 reset
+	 */
+	rst_deco_cntrl.whole_reg = hw->pfnReadFPGARegister(hw->adp, MISC_PERST_DECODER_CTRL);
+	rst_deco_cntrl.stop_bcm_7412_clk = 0;
+	rst_deco_cntrl.bcm7412_rst = 1;
+	hw->pfnWriteFPGARegister(hw->adp, MISC_PERST_DECODER_CTRL, rst_deco_cntrl.whole_reg);
+	msleep_interruptible(50);
+
+	rst_deco_cntrl.whole_reg = hw->pfnReadFPGARegister(hw->adp, MISC_PERST_DECODER_CTRL);
+	rst_deco_cntrl.bcm7412_rst = 0;
+	hw->pfnWriteFPGARegister(hw->adp, MISC_PERST_DECODER_CTRL, rst_deco_cntrl.whole_reg);
+	msleep_interruptible(50);
+
+	/* Disable OTP_CONTENT_MISC to 0 to disable all secure modes */
+	hw->pfnWriteFPGARegister(hw->adp, OTP_CONTENT_MISC, 0);
+
+	/* Clear bit 29 of 0x404 */
+	temp = hw->pfnReadFPGARegister(hw->adp, PCIE_TL_TRANSACTION_CONFIGURATION);
+	temp &= ~BC_BIT(29);
+	hw->pfnWriteFPGARegister(hw->adp, PCIE_TL_TRANSACTION_CONFIGURATION, temp);
+
+	/* 2.5V regulator must be set to 2.6 volts (+6%) */
+	hw->pfnWriteFPGARegister(hw->adp, MISC_PERST_VREG_CTRL, 0xF3);
+
+	return true;
+}
+
+bool crystalhd_link_put_in_reset(struct crystalhd_hw *hw)
+{
+	union link_misc_perst_deco_ctrl rst_deco_cntrl;
+	union link_misc_perst_clk_ctrl  rst_clk_cntrl;
+	uint32_t                  temp;
+
+	/*
+	 * Decoder clocks: MISC_PERST_DECODER_CTRL
+	 * Assert 7412 reset, delay
+	 * Assert 7412 stop clock
+	 */
+	rst_deco_cntrl.whole_reg = hw->pfnReadFPGARegister(hw->adp, MISC_PERST_DECODER_CTRL);
+	rst_deco_cntrl.stop_bcm_7412_clk = 1;
+	hw->pfnWriteFPGARegister(hw->adp, MISC_PERST_DECODER_CTRL, rst_deco_cntrl.whole_reg);
+	msleep_interruptible(50);
+
+	/* Bus Arbiter Timeout: GISB_ARBITER_TIMER
+	 * Set internal bus arbiter timeout to 40us based on core clock speed
+	 * (6.75MHZ * 40us = 0x10E)
+	 */
+	hw->pfnWriteFPGARegister(hw->adp, GISB_ARBITER_TIMER, 0x10E);
+
+	/* Link clocks: MISC_PERST_CLOCK_CTRL
+	 * Stop core clk, delay
+	 * Set alternate clk, delay, set PLL power down
+	 */
+	rst_clk_cntrl.whole_reg = hw->pfnReadFPGARegister(hw->adp, MISC_PERST_CLOCK_CTRL);
+	rst_clk_cntrl.stop_core_clk = 1;
+	rst_clk_cntrl.sel_alt_clk = 1;
+	hw->pfnWriteFPGARegister(hw->adp, MISC_PERST_CLOCK_CTRL, rst_clk_cntrl.whole_reg);
+	msleep_interruptible(50);
+
+	rst_clk_cntrl.whole_reg = hw->pfnReadFPGARegister(hw->adp, MISC_PERST_CLOCK_CTRL);
+	rst_clk_cntrl.pll_pwr_dn = 1;
+	hw->pfnWriteFPGARegister(hw->adp, MISC_PERST_CLOCK_CTRL, rst_clk_cntrl.whole_reg);
+
+	/*
+	 * Read and restore the Transaction Configuration Register
+	 * after core reset
+	 */
+	temp = hw->pfnReadFPGARegister(hw->adp, PCIE_TL_TRANSACTION_CONFIGURATION);
+
+	/*
+	 * Link core soft reset: MISC3_RESET_CTRL
+	 * - Write BIT[0]=1 and read it back for core reset to take place
+	 */
+	hw->pfnWriteFPGARegister(hw->adp, MISC3_RESET_CTRL, 1);
+	rst_deco_cntrl.whole_reg = hw->pfnReadFPGARegister(hw->adp, MISC3_RESET_CTRL);
+	msleep_interruptible(50);
+
+	/* restore the transaction configuration register */
+	hw->pfnWriteFPGARegister(hw->adp, PCIE_TL_TRANSACTION_CONFIGURATION, temp);
+
+	return true;
+}
+
+void crystalhd_link_disable_interrupts(struct crystalhd_hw *hw)
+{
+	union intr_mask_reg   intr_mask;
+	intr_mask.whole_reg = hw->pfnReadFPGARegister(hw->adp, INTR_INTR_MSK_STS_REG);
+	intr_mask.mask_pcie_err = 1;
+	intr_mask.mask_pcie_rbusmast_err = 1;
+	intr_mask.mask_pcie_rgr_bridge   = 1;
+	intr_mask.mask_rx_done = 1;
+	intr_mask.mask_rx_err  = 1;
+	intr_mask.mask_tx_done = 1;
+	intr_mask.mask_tx_err  = 1;
+	hw->pfnWriteFPGARegister(hw->adp, INTR_INTR_MSK_SET_REG, intr_mask.whole_reg);
+
+	return;
+}
+
+void crystalhd_link_enable_interrupts(struct crystalhd_hw *hw)
+{
+	union intr_mask_reg   intr_mask;
+	intr_mask.whole_reg = hw->pfnReadFPGARegister(hw->adp, INTR_INTR_MSK_STS_REG);
+	intr_mask.mask_pcie_err = 1;
+	intr_mask.mask_pcie_rbusmast_err = 1;
+	intr_mask.mask_pcie_rgr_bridge   = 1;
+	intr_mask.mask_rx_done = 1;
+	intr_mask.mask_rx_err  = 1;
+	intr_mask.mask_tx_done = 1;
+	intr_mask.mask_tx_err  = 1;
+	hw->pfnWriteFPGARegister(hw->adp, INTR_INTR_MSK_CLR_REG, intr_mask.whole_reg);
+
+	return;
+}
+
+void crystalhd_link_clear_errors(struct crystalhd_hw *hw)
+{
+	uint32_t reg;
+
+	/* Writing a 1 to a set bit clears that bit */
+	reg = hw->pfnReadFPGARegister(hw->adp, MISC1_Y_RX_ERROR_STATUS);
+	if (reg)
+		hw->pfnWriteFPGARegister(hw->adp, MISC1_Y_RX_ERROR_STATUS, reg);
+
+	reg = hw->pfnReadFPGARegister(hw->adp, MISC1_UV_RX_ERROR_STATUS);
+	if (reg)
+		hw->pfnWriteFPGARegister(hw->adp, MISC1_UV_RX_ERROR_STATUS, reg);
+
+	reg = hw->pfnReadFPGARegister(hw->adp, MISC1_TX_DMA_ERROR_STATUS);
+	if (reg)
+		hw->pfnWriteFPGARegister(hw->adp, MISC1_TX_DMA_ERROR_STATUS, reg);
+}
+
+void crystalhd_link_clear_interrupts(struct crystalhd_hw *hw)
+{
+	uint32_t intr_sts =  hw->pfnReadFPGARegister(hw->adp, INTR_INTR_STATUS);
+
+	if (intr_sts) {
+		hw->pfnWriteFPGARegister(hw->adp, INTR_INTR_CLR_REG, intr_sts);
+
+		/* Write End Of Interrupt for PCIE */
+		hw->pfnWriteFPGARegister(hw->adp, INTR_EOI_CTRL, 1);
+	}
+}
+
+void crystalhd_link_soft_rst(struct crystalhd_hw *hw)
+{
+	uint32_t val;
+
+	/* Assert c011 soft reset*/
+	hw->pfnWriteDevRegister(hw->adp, DecHt_HostSwReset, 0x00000001);
+	msleep_interruptible(50);
+
+	/* Release c011 soft reset*/
+	hw->pfnWriteDevRegister(hw->adp, DecHt_HostSwReset, 0x00000000);
+
+	/* Disable Stuffing..*/
+	val = hw->pfnReadFPGARegister(hw->adp, MISC2_GLOBAL_CTRL);
+	val |= BC_BIT(8);
+	hw->pfnWriteFPGARegister(hw->adp, MISC2_GLOBAL_CTRL, val);
+}
+
+bool crystalhd_link_load_firmware_config(struct crystalhd_hw *hw)
+{
+	uint32_t i = 0, reg;
+
+	hw->pfnWriteFPGARegister(hw->adp, DCI_DRAM_BASE_ADDR, (BC_DRAM_FW_CFG_ADDR >> 19));
+
+	hw->pfnWriteFPGARegister(hw->adp, AES_CMD, 0);
+	hw->pfnWriteFPGARegister(hw->adp, AES_CONFIG_INFO, (BC_DRAM_FW_CFG_ADDR & 0x7FFFF));
+	hw->pfnWriteFPGARegister(hw->adp, AES_CMD, 0x1);
+
+	for (i = 0; i < 100; ++i) {
+		reg = hw->pfnReadFPGARegister(hw->adp, AES_STATUS);
+		if (reg & 0x1)
+			return true;
+		msleep_interruptible(10);
+	}
+
+	return false;
+}
+
+
+bool crystalhd_link_start_device(struct crystalhd_hw *hw)
+{
+	uint32_t dbg_options, glb_cntrl = 0, reg_pwrmgmt = 0;
+	struct device *dev;
+
+	if (!hw)
+		return -EINVAL;
+
+	dev = &hw->adp->pdev->dev;
+
+	dev_dbg(dev, "Starting Crystal HD BCM70012 Device\n");
+
+	if (!crystalhd_link_bring_out_of_rst(hw)) {
+		dev_err(dev, "Failed To Bring BCM70012 Out Of Reset\n");
+		return false;
+	}
+
+	crystalhd_link_disable_interrupts(hw);
+
+	crystalhd_link_clear_errors(hw);
+
+	crystalhd_link_clear_interrupts(hw);
+
+	crystalhd_link_enable_interrupts(hw);
+
+	/* Enable the option for getting the total no. of DWORDS
+	 * that have been transfered by the RXDMA engine
+	 */
+	dbg_options = hw->pfnReadFPGARegister(hw->adp, MISC1_DMA_DEBUG_OPTIONS_REG);
+	dbg_options |= 0x10;
+	hw->pfnWriteFPGARegister(hw->adp, MISC1_DMA_DEBUG_OPTIONS_REG, dbg_options);
+
+	/* Enable PCI Global Control options */
+	glb_cntrl = hw->pfnReadFPGARegister(hw->adp, MISC2_GLOBAL_CTRL);
+	glb_cntrl |= 0x100;
+	glb_cntrl |= 0x8000;
+	hw->pfnWriteFPGARegister(hw->adp, MISC2_GLOBAL_CTRL, glb_cntrl);
+
+	crystalhd_link_enable_interrupts(hw);
+
+	crystalhd_link_soft_rst(hw);
+	crystalhd_link_start_dram(hw);
+	crystalhd_link_enable_uarts(hw);
+
+	/* Disable L1 ASPM while video is playing as this causes performance problems otherwise */
+	reg_pwrmgmt = hw->pfnReadFPGARegister(hw->adp, PCIE_DLL_DATA_LINK_CONTROL);
+	reg_pwrmgmt &= ~ASPM_L1_ENABLE;
+
+	hw->pfnWriteFPGARegister(hw->adp, PCIE_DLL_DATA_LINK_CONTROL, reg_pwrmgmt);
+
+	return true;
+}
+
+bool crystalhd_link_stop_device(struct crystalhd_hw *hw)
+{
+	uint32_t reg;
+	enum BC_STATUS sts;
+
+	dev_dbg(&hw->adp->pdev->dev, "Stopping Crystal HD BCM70012 Device\n");
+	sts = crystalhd_link_put_ddr2sleep(hw);
+	if (sts != BC_STS_SUCCESS) {
+		dev_err(&hw->adp->pdev->dev, "Failed to Put DDR To Sleep!!\n");
+		return BC_STS_ERROR;
+	}
+
+	/* Clear and disable interrupts */
+	crystalhd_link_disable_interrupts(hw);
+	crystalhd_link_clear_errors(hw);
+	crystalhd_link_clear_interrupts(hw);
+
+	if (!crystalhd_link_put_in_reset(hw))
+		dev_err(&hw->adp->pdev->dev, "Failed to Put Link To Reset State\n");
+
+	reg = hw->pfnReadFPGARegister(hw->adp, PCIE_DLL_DATA_LINK_CONTROL);
+	reg |= ASPM_L1_ENABLE;
+	hw->pfnWriteFPGARegister(hw->adp, PCIE_DLL_DATA_LINK_CONTROL, reg);
+
+	/* Set PCI Clk Req */
+	reg = hw->pfnReadFPGARegister(hw->adp, PCIE_CLK_REQ_REG);
+	reg |= PCI_CLK_REQ_ENABLE;
+	hw->pfnWriteFPGARegister(hw->adp, PCIE_CLK_REQ_REG, reg);
+
+	return true;
+}
+
+uint32_t link_GetPicInfoLineNum(struct crystalhd_dio_req *dio, uint8_t *base)
+{
+	uint32_t PicInfoLineNum = 0;
+
+	if (dio->uinfo.b422mode == MODE422_YUY2) {
+		PicInfoLineNum = ((uint32_t)(*(base + 6)) & 0xff)
+			| (((uint32_t)(*(base + 4)) << 8)  & 0x0000ff00)
+			| (((uint32_t)(*(base + 2)) << 16) & 0x00ff0000)
+			| (((uint32_t)(*(base + 0)) << 24) & 0xff000000);
+	} else if (dio->uinfo.b422mode == MODE422_UYVY) {
+		PicInfoLineNum = ((uint32_t)(*(base + 7)) & 0xff)
+			| (((uint32_t)(*(base + 5)) << 8)  & 0x0000ff00)
+			| (((uint32_t)(*(base + 3)) << 16) & 0x00ff0000)
+			| (((uint32_t)(*(base + 1)) << 24) & 0xff000000);
+	} else {
+		PicInfoLineNum = ((uint32_t)(*(base + 3)) & 0xff)
+			| (((uint32_t)(*(base + 2)) << 8)  & 0x0000ff00)
+			| (((uint32_t)(*(base + 1)) << 16) & 0x00ff0000)
+			| (((uint32_t)(*(base + 0)) << 24) & 0xff000000);
+	}
+
+	return PicInfoLineNum;
+}
+
+uint32_t link_GetMode422Data(struct crystalhd_dio_req *dio,
+			       struct BC_PIC_INFO_BLOCK *pPicInfoLine, int type)
+{
+	int i;
+	uint32_t offset = 0, val = 0;
+	uint8_t *tmp;
+	tmp = (uint8_t *)&val;
+
+	if (type == 1)
+		offset = OFFSETOF(struct BC_PIC_INFO_BLOCK, picture_meta_payload);
+	else if (type == 2)
+		offset = OFFSETOF(struct BC_PIC_INFO_BLOCK, height);
+	else
+		offset = 0;
+
+	if (dio->uinfo.b422mode == MODE422_YUY2) {
+		for (i = 0; i < 4; i++)
+			((uint8_t*)tmp)[i] =
+				((uint8_t*)pPicInfoLine)[(offset + i) * 2];
+	} else if (dio->uinfo.b422mode == MODE422_UYVY) {
+		for (i = 0; i < 4; i++)
+			((uint8_t*)tmp)[i] =
+				((uint8_t*)pPicInfoLine)[(offset + i) * 2 + 1];
+	}
+
+	return val;
+}
+
+uint32_t link_GetMetaDataFromPib(struct crystalhd_dio_req *dio,
+				   struct BC_PIC_INFO_BLOCK *pPicInfoLine)
+{
+	uint32_t picture_meta_payload = 0;
+
+	if (dio->uinfo.b422mode)
+		picture_meta_payload = link_GetMode422Data(dio, pPicInfoLine, 1);
+	else
+		picture_meta_payload = pPicInfoLine->picture_meta_payload;
+
+	return BC_SWAP32(picture_meta_payload);
+}
+
+uint32_t link_GetHeightFromPib(struct crystalhd_dio_req *dio,
+				 struct BC_PIC_INFO_BLOCK *pPicInfoLine)
+{
+	uint32_t height = 0;
+
+	if (dio->uinfo.b422mode)
+		height = link_GetMode422Data(dio, pPicInfoLine, 2);
+	else
+		height = pPicInfoLine->height;
+
+	return BC_SWAP32(height);
+}
+
+/* This function cannot be called from ISR context since it uses APIs that can sleep */
+bool link_GetPictureInfo(struct crystalhd_hw *hw, uint32_t picHeight, uint32_t picWidth, struct crystalhd_dio_req *dio,
+			   uint32_t *PicNumber, uint64_t *PicMetaData)
+{
+	uint32_t PicInfoLineNum = 0, HeightInPib = 0, offset = 0, size = 0;
+	struct BC_PIC_INFO_BLOCK *pPicInfoLine = NULL;
+	uint32_t pic_number = 0;
+	uint8_t *tmp = (uint8_t *)&pic_number;
+	int i;
+	unsigned long res = 0;
+
+	dev_dbg(&hw->adp->pdev->dev, "getting Picture Info\n");
+
+	*PicNumber = 0;
+	*PicMetaData = 0;
+
+	if (!dio || !picWidth)
+		goto getpictureinfo_err_nosem;
+
+/*	if(down_interruptible(&hw->fetch_sem)) */
+/*		goto getpictureinfo_err_nosem; */
+
+	dio->pib_va = kmalloc(2 * sizeof(struct BC_PIC_INFO_BLOCK) + 16, GFP_KERNEL); /* since copy_from_user can sleep anyway */
+	if(dio->pib_va == NULL)
+		goto getpictureinfo_err;
+
+	res = copy_from_user(dio->pib_va, (void *)dio->uinfo.xfr_buff, 8);
+	if (res != 0)
+		goto getpictureinfo_err;
+
+	/*
+	 * -- Ajitabh[01-16-2009]: Strictly check against done size.
+	 * -- we have seen that the done size sometimes comes less without
+	 * -- any error indicated to the driver. So we change the limit
+	 * -- to check against the done size rather than the full buffer size
+	 * -- this way we will always make sure that the PIB is recieved by
+	 * -- the driver.
+	 */
+	/* Limit = Base + pRxDMAReq->RxYDMADesc.RxBuffSz; */
+	/* Limit = Base + (pRxDMAReq->RxYDoneSzInDword * 4); */
+/*	Limit = dio->uinfo.xfr_buff + dio->uinfo.xfr_len; */
+
+	PicInfoLineNum = link_GetPicInfoLineNum(dio, dio->pib_va);
+	if (PicInfoLineNum > 1092) {
+		dev_dbg(&hw->adp->pdev->dev, "Invalid Line Number[%x]\n", (int)PicInfoLineNum);
+		goto getpictureinfo_err;
+	}
+
+	/*
+	 * -- Ajitabh[01-16-2009]: Added the check for validating the
+	 * -- PicInfoLine Number. This function is only called for link so we
+	 * -- do not have to check for height+1 or (Height+1)/2 as we are doing
+	 * -- in DIL. In DIL we need that because for flea firmware is padding
+	 * -- the data to make it 16 byte aligned. This Validates the reception
+	 * -- of PIB itself.
+	 */
+	if (picHeight) {
+		if ((PicInfoLineNum != picHeight) &&
+		    (PicInfoLineNum != picHeight/2)) {
+			dev_dbg(&hw->adp->pdev->dev, "PicInfoLineNum[%d] != PICHeight "
+				"Or PICHeight/2 [%d]\n",
+				(int)PicInfoLineNum, picHeight);
+			goto getpictureinfo_err;
+		}
+	}
+
+	/* calc pic info line offset */
+	if (dio->uinfo.b422mode) {
+		size = 2 * sizeof(struct BC_PIC_INFO_BLOCK);
+		offset = (PicInfoLineNum * picWidth * 2) + 8;
+	} else {
+		size = sizeof(struct BC_PIC_INFO_BLOCK);
+		offset = (PicInfoLineNum * picWidth) + 4;
+	}
+
+	res = copy_from_user(dio->pib_va, (void *)(dio->uinfo.xfr_buff+offset), size);
+	if (res != 0)
+		goto getpictureinfo_err;
+	pPicInfoLine = (struct BC_PIC_INFO_BLOCK *)(dio->pib_va);
+
+/*	if (((uint8_t *)pPicInfoLine < Base) || */
+/*	    ((uint8_t *)pPicInfoLine > Limit)) { */
+/*		dev_err(dev, "Base Limit Check Failed for Extracting " */
+/*			"the PIB\n"); */
+/*		goto getpictureinfo_err; */
+/*	} */
+
+	/*
+	 * -- Ajitabh[01-16-2009]:
+	 * We have seen that the data gets shifted for some repeated frames.
+	 * To detect those we use PicInfoLineNum and compare it with height.
+	 */
+
+	HeightInPib = link_GetHeightFromPib(dio, pPicInfoLine);
+	if ((PicInfoLineNum != HeightInPib) &&
+	    (PicInfoLineNum != HeightInPib / 2)) {
+		printk("Height Match Failed: HeightInPIB[%d] "
+			"PicInfoLineNum[%d]\n",
+			(int)HeightInPib, (int)PicInfoLineNum);
+		goto getpictureinfo_err;
+	}
+
+	/* get pic meta data from pib */
+	*PicMetaData = link_GetMetaDataFromPib(dio, pPicInfoLine);
+	/* get pic number from pib */
+	/* calc pic info line offset */
+	if (dio->uinfo.b422mode)
+		offset = (PicInfoLineNum * picWidth * 2);
+	else
+		offset = (PicInfoLineNum * picWidth);
+
+	res = copy_from_user(dio->pib_va, (void *)(dio->uinfo.xfr_buff+offset), 12);
+	if (res != 0)
+		goto getpictureinfo_err;
+
+	if (dio->uinfo.b422mode == MODE422_YUY2) {
+		for (i = 0; i < 4; i++)
+			((uint8_t *)tmp)[i] = ((uint8_t *)dio->pib_va)[i * 2];
+	} else if (dio->uinfo.b422mode == MODE422_UYVY) {
+		for (i = 0; i < 4; i++)
+			((uint8_t *)tmp)[i] = ((uint8_t *)dio->pib_va)[(i * 2) + 1];
+	} else
+		pic_number = *(uint32_t *)(dio->pib_va);
+
+	*PicNumber =  BC_SWAP32(pic_number);
+
+	if(dio->pib_va)
+		kfree(dio->pib_va);
+
+/*	up(&hw->fetch_sem); */
+
+	return true;
+
+getpictureinfo_err:
+/*	up(&hw->fetch_sem); */
+
+getpictureinfo_err_nosem:
+	if(dio->pib_va)
+		kfree(dio->pib_va);
+	*PicNumber = 0;
+	*PicMetaData = 0;
+
+	return false;
+}
+
+uint32_t link_GetRptDropParam(struct crystalhd_hw *hw, uint32_t picHeight, uint32_t picWidth, void* pRxDMAReq)
+{
+	uint32_t PicNumber = 0, result = 0;
+	uint64_t PicMetaData = 0;
+
+	if(link_GetPictureInfo(hw, picHeight, picWidth, ((struct crystalhd_rx_dma_pkt *)pRxDMAReq)->dio_req,
+				&PicNumber, &PicMetaData))
+		result = PicNumber;
+
+	return result;
+}
+
+/*
+* This function gets the next picture metadata payload
+* from the decoded picture in ReadyQ (if there was any)
+* and returns it. THIS IS ONLY USED FOR LINK.
+*/
+bool crystalhd_link_peek_next_decoded_frame(struct crystalhd_hw *hw,
+					  uint64_t *meta_payload, uint32_t *picNumFlags,
+					  uint32_t PicWidth)
+{
+	uint32_t PicNumber = 0;
+	unsigned long flags = 0;
+	struct crystalhd_dioq *ioq;
+	struct crystalhd_elem *tmp;
+	struct crystalhd_rx_dma_pkt *rpkt;
+
+	*meta_payload = 0;
+
+	ioq = hw->rx_rdyq;
+	spin_lock_irqsave(&ioq->lock, flags);
+
+	if ((ioq->count > 0) && (ioq->head != (struct crystalhd_elem *)&ioq->head)) {
+		tmp = ioq->head;
+		spin_unlock_irqrestore(&ioq->lock, flags);
+		rpkt = (struct crystalhd_rx_dma_pkt *)tmp->data;
+		if (rpkt) {
+			/* We are in process context here and have to check if we have repeated pictures */
+			/* Drop repeated pictures or garbabge pictures here */
+			/* This is because if we advertize a valid picture here, but later drop it */
+			/* It will cause single threaded applications to hang, or errors in applications that expect */
+			/* pictures not to be dropped once we have advertized their availability */
+
+			/* If format change packet, then return with out checking anything */
+			if (!(rpkt->flags & (COMP_FLAG_PIB_VALID | COMP_FLAG_FMT_CHANGE))) {
+				link_GetPictureInfo(hw, hw->PICHeight, hw->PICWidth, rpkt->dio_req,
+									&PicNumber, meta_payload);
+				if(!PicNumber || (PicNumber == hw->LastPicNo) || (PicNumber == hw->LastTwoPicNo)) {
+					/* discard picture */
+					if(PicNumber != 0) {
+						hw->LastTwoPicNo = hw->LastPicNo;
+						hw->LastPicNo = PicNumber;
+					}
+					rpkt = crystalhd_dioq_fetch(hw->rx_rdyq);
+					if (rpkt) {
+						crystalhd_dioq_add(hw->rx_freeq, rpkt, false, rpkt->pkt_tag);
+						rpkt = NULL;
+					}
+					*meta_payload = 0;
+				}
+				return true;
+				/* Do not update the picture numbers here since they will be updated on the actual fetch of a valid picture */
+			}
+			else
+				return false; /* don't use the meta_payload information */
+		}
+		else
+			return false;
+	}
+	spin_unlock_irqrestore(&ioq->lock, flags);
+
+	return false;
+}
+
+bool crystalhd_link_check_input_full(struct crystalhd_hw *hw,
+				   uint32_t needed_sz, uint32_t *empty_sz,
+				   bool b_188_byte_pkts, uint8_t *flags)
+{
+	uint32_t base, end, writep, readp;
+	uint32_t cpbSize, cpbFullness, fifoSize;
+
+	if (*flags & 0x02) { /* ASF Bit is set */
+		base   = hw->pfnReadDevRegister(hw->adp, REG_Dec_TsAudCDB2Base);
+		end    = hw->pfnReadDevRegister(hw->adp, REG_Dec_TsAudCDB2End);
+		writep = hw->pfnReadDevRegister(hw->adp, REG_Dec_TsAudCDB2Wrptr);
+		readp  = hw->pfnReadDevRegister(hw->adp, REG_Dec_TsAudCDB2Rdptr);
+	} else if (b_188_byte_pkts) { /*Encrypted 188 byte packets*/
+		base   = hw->pfnReadDevRegister(hw->adp, REG_Dec_TsUser0Base);
+		end    = hw->pfnReadDevRegister(hw->adp, REG_Dec_TsUser0End);
+		writep = hw->pfnReadDevRegister(hw->adp, REG_Dec_TsUser0Wrptr);
+		readp  = hw->pfnReadDevRegister(hw->adp, REG_Dec_TsUser0Rdptr);
+	} else {
+		base   = hw->pfnReadDevRegister(hw->adp, REG_DecCA_RegCinBase);
+		end    = hw->pfnReadDevRegister(hw->adp, REG_DecCA_RegCinEnd);
+		writep = hw->pfnReadDevRegister(hw->adp, REG_DecCA_RegCinWrPtr);
+		readp  = hw->pfnReadDevRegister(hw->adp, REG_DecCA_RegCinRdPtr);
+	}
+
+	cpbSize = end - base;
+	if (writep >= readp)
+		cpbFullness = writep - readp;
+	else
+		cpbFullness = (end - base) - (readp - writep);
+
+	fifoSize = cpbSize - cpbFullness;
+
+
+	if (fifoSize < BC_INFIFO_THRESHOLD)
+	{
+		*empty_sz = 0;
+		return true;
+	}
+
+	if (needed_sz > (fifoSize - BC_INFIFO_THRESHOLD))
+	{
+		*empty_sz = 0;
+		return true;
+	}
+	*empty_sz = fifoSize - BC_INFIFO_THRESHOLD;
+
+	return false;
+}
+
+bool crystalhd_link_tx_list0_handler(struct crystalhd_hw *hw, uint32_t err_sts)
+{
+	uint32_t err_mask, tmp;
+
+	err_mask = MISC1_TX_DMA_ERROR_STATUS_TX_L0_DESC_TX_ABORT_ERRORS_MASK |
+		MISC1_TX_DMA_ERROR_STATUS_TX_L0_DMA_DATA_TX_ABORT_ERRORS_MASK |
+		MISC1_TX_DMA_ERROR_STATUS_TX_L0_FIFO_FULL_ERRORS_MASK;
+
+	if (!(err_sts & err_mask))
+		return false;
+
+	dev_err(&hw->adp->pdev->dev, "Error on Tx-L0 %x\n", err_sts);
+
+	tmp = err_mask;
+
+	if (err_sts & MISC1_TX_DMA_ERROR_STATUS_TX_L0_FIFO_FULL_ERRORS_MASK)
+		tmp &= ~MISC1_TX_DMA_ERROR_STATUS_TX_L0_FIFO_FULL_ERRORS_MASK;
+
+	if (tmp) {
+		/* reset list index.*/
+		hw->tx_list_post_index = 0;
+	}
+
+	tmp = err_sts & err_mask;
+	hw->pfnWriteFPGARegister(hw->adp, MISC1_TX_DMA_ERROR_STATUS, tmp);
+
+	return true;
+}
+
+bool crystalhd_link_tx_list1_handler(struct crystalhd_hw *hw, uint32_t err_sts)
+{
+	uint32_t err_mask, tmp;
+
+	err_mask = MISC1_TX_DMA_ERROR_STATUS_TX_L1_DESC_TX_ABORT_ERRORS_MASK |
+		MISC1_TX_DMA_ERROR_STATUS_TX_L1_DMA_DATA_TX_ABORT_ERRORS_MASK |
+		MISC1_TX_DMA_ERROR_STATUS_TX_L1_FIFO_FULL_ERRORS_MASK;
+
+	if (!(err_sts & err_mask))
+		return false;
+
+	dev_err(&hw->adp->pdev->dev, "Error on Tx-L1 %x\n", err_sts);
+
+	tmp = err_mask;
+
+	if (err_sts & MISC1_TX_DMA_ERROR_STATUS_TX_L1_FIFO_FULL_ERRORS_MASK)
+		tmp &= ~MISC1_TX_DMA_ERROR_STATUS_TX_L1_FIFO_FULL_ERRORS_MASK;
+
+	if (tmp) {
+		/* reset list index.*/
+		hw->tx_list_post_index = 0;
+	}
+
+	tmp = err_sts & err_mask;
+	hw->pfnWriteFPGARegister(hw->adp, MISC1_TX_DMA_ERROR_STATUS, tmp);
+
+	return true;
+}
+
+void crystalhd_link_tx_isr(struct crystalhd_hw *hw, uint32_t int_sts)
+{
+	uint32_t err_sts;
+
+	if (int_sts & INTR_INTR_STATUS_L0_TX_DMA_DONE_INTR_MASK)
+		crystalhd_hw_tx_req_complete(hw, hw->tx_ioq_tag_seed + 0,
+					   BC_STS_SUCCESS);
+
+	if (int_sts & INTR_INTR_STATUS_L1_TX_DMA_DONE_INTR_MASK)
+		crystalhd_hw_tx_req_complete(hw, hw->tx_ioq_tag_seed + 1,
+					     BC_STS_SUCCESS);
+
+	if (!(int_sts & (INTR_INTR_STATUS_L0_TX_DMA_ERR_INTR_MASK |
+			 INTR_INTR_STATUS_L1_TX_DMA_ERR_INTR_MASK)))
+		/* No error mask set.. */
+		return;
+
+	/* Handle Tx errors. */
+	err_sts = hw->pfnReadFPGARegister(hw->adp, MISC1_TX_DMA_ERROR_STATUS);
+
+	if (crystalhd_link_tx_list0_handler(hw, err_sts))
+		crystalhd_hw_tx_req_complete(hw, hw->tx_ioq_tag_seed + 0,
+					     BC_STS_ERROR);
+
+	if (crystalhd_link_tx_list1_handler(hw, err_sts))
+		crystalhd_hw_tx_req_complete(hw, hw->tx_ioq_tag_seed + 1,
+					     BC_STS_ERROR);
+
+	hw->stats.tx_errors++;
+}
+
+void crystalhd_link_start_tx_dma_engine(struct crystalhd_hw *hw, uint8_t list_id, addr_64 desc_addr)
+{
+	uint32_t dma_cntrl;
+	uint32_t first_desc_u_addr, first_desc_l_addr;
+
+	if (list_id == 0) {
+		first_desc_u_addr = MISC1_TX_FIRST_DESC_U_ADDR_LIST0;
+		first_desc_l_addr = MISC1_TX_FIRST_DESC_L_ADDR_LIST0;
+	} else {
+		first_desc_u_addr = MISC1_TX_FIRST_DESC_U_ADDR_LIST1;
+		first_desc_l_addr = MISC1_TX_FIRST_DESC_L_ADDR_LIST1;
+	}
+
+	dma_cntrl = hw->pfnReadFPGARegister(hw->adp,MISC1_TX_SW_DESC_LIST_CTRL_STS);
+	if (!(dma_cntrl & DMA_START_BIT)) {
+		dma_cntrl |= DMA_START_BIT;
+		hw->pfnWriteFPGARegister(hw->adp, MISC1_TX_SW_DESC_LIST_CTRL_STS,
+			       dma_cntrl);
+	}
+
+	hw->pfnWriteFPGARegister(hw->adp, first_desc_u_addr, desc_addr.high_part);
+
+	hw->pfnWriteFPGARegister(hw->adp, first_desc_l_addr, desc_addr.low_part | 0x01);
+						/* Be sure we set the valid bit ^^^^ */
+	return;
+}
+
+/* _CHECK_THIS_
+ *
+ * Verify if the Stop generates a completion interrupt or not.
+ * if it does not generate an interrupt, then add polling here.
+ */
+enum BC_STATUS crystalhd_link_stop_tx_dma_engine(struct crystalhd_hw *hw)
+{
+	struct device *dev;
+	uint32_t dma_cntrl, cnt = 30;
+	uint32_t l1 = 1, l2 = 1;
+
+	dma_cntrl = hw->pfnReadFPGARegister(hw->adp, MISC1_TX_SW_DESC_LIST_CTRL_STS);
+
+	dev = &hw->adp->pdev->dev;
+
+	dev_dbg(dev, "Stopping TX DMA Engine..\n");
+
+	if (!(dma_cntrl & DMA_START_BIT)) {
+		hw->tx_list_post_index = 0;
+		dev_dbg(dev, "Already Stopped\n");
+		return BC_STS_SUCCESS;
+	}
+
+	crystalhd_link_disable_interrupts(hw);
+
+	/* Issue stop to HW */
+	dma_cntrl &= ~DMA_START_BIT;
+	hw->pfnWriteFPGARegister(hw->adp, MISC1_TX_SW_DESC_LIST_CTRL_STS, dma_cntrl);
+
+	dev_dbg(dev, "Cleared the DMA Start bit\n");
+
+	/* Poll for 3seconds (30 * 100ms) on both the lists..*/
+	while ((l1 || l2) && cnt) {
+
+		if (l1) {
+			l1 = hw->pfnReadFPGARegister(hw->adp,
+				MISC1_TX_FIRST_DESC_L_ADDR_LIST0);
+			l1 &= DMA_START_BIT;
+		}
+
+		if (l2) {
+			l2 = hw->pfnReadFPGARegister(hw->adp,
+				MISC1_TX_FIRST_DESC_L_ADDR_LIST1);
+			l2 &= DMA_START_BIT;
+		}
+
+		msleep_interruptible(100);
+
+		cnt--;
+	}
+
+	if (!cnt) {
+		dev_err(dev, "Failed to stop TX DMA.. l1 %d, l2 %d\n", l1, l2);
+		crystalhd_link_enable_interrupts(hw);
+		return BC_STS_ERROR;
+	}
+
+	hw->tx_list_post_index = 0;
+	dev_dbg(dev, "stopped TX DMA..\n");
+	crystalhd_link_enable_interrupts(hw);
+
+	return BC_STS_SUCCESS;
+}
+
+uint32_t crystalhd_link_get_pib_avail_cnt(struct crystalhd_hw *hw)
+{
+	/*
+	* Position of the PIB Entries can be found at
+	* 0th and the 1st location of the Circular list.
+	*/
+	uint32_t Q_addr;
+	uint32_t pib_cnt, r_offset, w_offset;
+
+	Q_addr = hw->pib_del_Q_addr;
+
+	/* Get the Read Pointer */
+	crystalhd_link_mem_rd(hw, Q_addr, 1, &r_offset);
+
+	/* Get the Write Pointer */
+	crystalhd_link_mem_rd(hw, Q_addr + sizeof(uint32_t), 1, &w_offset);
+
+	if (r_offset == w_offset)
+		return 0;	/* Queue is empty */
+
+	if (w_offset > r_offset)
+		pib_cnt = w_offset - r_offset;
+	else
+		pib_cnt = (w_offset + MAX_PIB_Q_DEPTH) -
+			  (r_offset + MIN_PIB_Q_DEPTH);
+
+	if (pib_cnt > MAX_PIB_Q_DEPTH) {
+		dev_err(&hw->adp->pdev->dev, "Invalid PIB Count (%u)\n", pib_cnt);
+		return 0;
+	}
+
+	return pib_cnt;
+}
+
+uint32_t crystalhd_link_get_addr_from_pib_Q(struct crystalhd_hw *hw)
+{
+	uint32_t Q_addr;
+	uint32_t addr_entry, r_offset, w_offset;
+
+	Q_addr = hw->pib_del_Q_addr;
+
+	/* Get the Read Pointer 0Th Location is Read Pointer */
+	crystalhd_link_mem_rd(hw, Q_addr, 1, &r_offset);
+
+	/* Get the Write Pointer 1st Location is Write pointer */
+	crystalhd_link_mem_rd(hw, Q_addr + sizeof(uint32_t), 1, &w_offset);
+
+	/* Queue is empty */
+	if (r_offset == w_offset)
+		return 0;
+
+	if ((r_offset < MIN_PIB_Q_DEPTH) || (r_offset >= MAX_PIB_Q_DEPTH))
+		return 0;
+
+	/* Get the Actual Address of the PIB */
+	crystalhd_link_mem_rd(hw, Q_addr + (r_offset * sizeof(uint32_t)),
+		       1, &addr_entry);
+
+	/* Increment the Read Pointer */
+	r_offset++;
+
+	if (MAX_PIB_Q_DEPTH == r_offset)
+		r_offset = MIN_PIB_Q_DEPTH;
+
+	/* Write back the read pointer to It's Location */
+	crystalhd_link_mem_wr(hw, Q_addr, 1, &r_offset);
+
+	return addr_entry;
+}
+
+bool crystalhd_link_rel_addr_to_pib_Q(struct crystalhd_hw *hw, uint32_t addr_to_rel)
+{
+	uint32_t Q_addr;
+	uint32_t r_offset, w_offset, n_offset;
+
+	Q_addr = hw->pib_rel_Q_addr;
+
+	/* Get the Read Pointer */
+	crystalhd_link_mem_rd(hw, Q_addr, 1, &r_offset);
+
+	/* Get the Write Pointer */
+	crystalhd_link_mem_rd(hw, Q_addr + sizeof(uint32_t), 1, &w_offset);
+
+	if ((r_offset < MIN_PIB_Q_DEPTH) ||
+	    (r_offset >= MAX_PIB_Q_DEPTH))
+		return false;
+
+	n_offset = w_offset + 1;
+
+	if (MAX_PIB_Q_DEPTH == n_offset)
+		n_offset = MIN_PIB_Q_DEPTH;
+
+	if (r_offset == n_offset)
+		return false; /* should never happen */
+
+	/* Write the DRAM ADDR to the Queue at Next Offset */
+	crystalhd_link_mem_wr(hw, Q_addr + (w_offset * sizeof(uint32_t)),
+		       1, &addr_to_rel);
+
+	/* Put the New value of the write pointer in Queue */
+	crystalhd_link_mem_wr(hw, Q_addr + sizeof(uint32_t), 1, &n_offset);
+
+	return true;
+}
+
+void link_cpy_pib_to_app(struct c011_pib *src_pib, struct BC_PIC_INFO_BLOCK *dst_pib)
+{
+	if (!src_pib || !dst_pib) {
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
+		return;
+	}
+
+	dst_pib->timeStamp		= 0;
+	dst_pib->picture_number		= src_pib->ppb.picture_number;
+	dst_pib->width			= src_pib->ppb.width;
+	dst_pib->height			= src_pib->ppb.height;
+	dst_pib->chroma_format		= src_pib->ppb.chroma_format;
+	dst_pib->pulldown		= src_pib->ppb.pulldown;
+	dst_pib->flags			= src_pib->ppb.flags;
+	dst_pib->sess_num		= src_pib->ptsStcOffset;
+	dst_pib->aspect_ratio		= src_pib->ppb.aspect_ratio;
+	dst_pib->colour_primaries	= src_pib->ppb.colour_primaries;
+	dst_pib->picture_meta_payload	= src_pib->ppb.picture_meta_payload;
+	dst_pib->frame_rate		= src_pib->resolution ;
+	return;
+}
+
+void crystalhd_link_proc_pib(struct crystalhd_hw *hw)
+{
+	unsigned int cnt;
+	struct c011_pib src_pib;
+	uint32_t pib_addr, pib_cnt;
+	struct BC_PIC_INFO_BLOCK *AppPib;
+	struct crystalhd_rx_dma_pkt *rx_pkt = NULL;
+
+	pib_cnt = crystalhd_link_get_pib_avail_cnt(hw);
+
+	if (!pib_cnt)
+		return;
+
+	for (cnt = 0; cnt < pib_cnt; cnt++) {
+		pib_addr = crystalhd_link_get_addr_from_pib_Q(hw);
+		crystalhd_link_mem_rd(hw, pib_addr, sizeof(struct c011_pib) / 4,
+				 (uint32_t *)&src_pib);
+
+		if (src_pib.bFormatChange) {
+			rx_pkt = (struct crystalhd_rx_dma_pkt *)
+					crystalhd_dioq_fetch(hw->rx_freeq);
+			if (!rx_pkt)
+				return;
+
+			rx_pkt->flags = 0;
+			rx_pkt->flags |= COMP_FLAG_PIB_VALID |
+					 COMP_FLAG_FMT_CHANGE;
+			AppPib = &rx_pkt->pib;
+			link_cpy_pib_to_app(&src_pib, AppPib);
+
+			hw->PICHeight = rx_pkt->pib.height;
+			if (rx_pkt->pib.width > 1280)
+				hw->PICWidth = 1920;
+			else if (rx_pkt->pib.width > 720)
+				hw->PICWidth = 1280;
+			else
+				hw->PICWidth = 720;
+
+			dev_info(&hw->adp->pdev->dev,
+				"[FMT CH] PIB:%x %x %x %x %x %x %x %x %x %x\n",
+				rx_pkt->pib.picture_number,
+				rx_pkt->pib.aspect_ratio,
+				rx_pkt->pib.chroma_format,
+				rx_pkt->pib.colour_primaries,
+				rx_pkt->pib.frame_rate,
+				rx_pkt->pib.height,
+				rx_pkt->pib.width,
+				rx_pkt->pib.n_drop,
+				rx_pkt->pib.pulldown,
+				rx_pkt->pib.ycom);
+
+			crystalhd_dioq_add(hw->rx_rdyq, (void *)rx_pkt,
+					   true, rx_pkt->pkt_tag);
+
+		}
+
+		crystalhd_link_rel_addr_to_pib_Q(hw, pib_addr);
+	}
+}
+
+void crystalhd_link_start_rx_dma_engine(struct crystalhd_hw *hw)
+{
+	uint32_t        dma_cntrl;
+
+	dma_cntrl = hw->pfnReadFPGARegister(hw->adp, MISC1_Y_RX_SW_DESC_LIST_CTRL_STS);
+	if (!(dma_cntrl & DMA_START_BIT)) {
+		dma_cntrl |= DMA_START_BIT;
+		hw->pfnWriteFPGARegister(hw->adp, MISC1_Y_RX_SW_DESC_LIST_CTRL_STS,
+				 dma_cntrl);
+	}
+
+	dma_cntrl = hw->pfnReadFPGARegister(hw->adp, MISC1_UV_RX_SW_DESC_LIST_CTRL_STS);
+	if (!(dma_cntrl & DMA_START_BIT)) {
+		dma_cntrl |= DMA_START_BIT;
+		hw->pfnWriteFPGARegister(hw->adp, MISC1_UV_RX_SW_DESC_LIST_CTRL_STS,
+				 dma_cntrl);
+	}
+
+	return;
+}
+
+void crystalhd_link_stop_rx_dma_engine(struct crystalhd_hw *hw)
+{
+	struct device *dev = &hw->adp->pdev->dev;
+	uint32_t dma_cntrl = 0, count = 30;
+	uint32_t l0y = 1, l0uv = 1, l1y = 1, l1uv = 1;
+
+	dma_cntrl = hw->pfnReadFPGARegister(hw->adp, MISC1_Y_RX_SW_DESC_LIST_CTRL_STS);
+	if ((dma_cntrl & DMA_START_BIT)) {
+		dma_cntrl &= ~DMA_START_BIT;
+		hw->pfnWriteFPGARegister(hw->adp, MISC1_Y_RX_SW_DESC_LIST_CTRL_STS,
+				 dma_cntrl);
+	}
+
+	dma_cntrl = hw->pfnReadFPGARegister(hw->adp, MISC1_UV_RX_SW_DESC_LIST_CTRL_STS);
+	if ((dma_cntrl & DMA_START_BIT)) {
+		dma_cntrl &= ~DMA_START_BIT;
+		hw->pfnWriteFPGARegister(hw->adp, MISC1_UV_RX_SW_DESC_LIST_CTRL_STS,
+				 dma_cntrl);
+	}
+
+	/* Poll for 3seconds (30 * 100ms) on both the lists..*/
+	while ((l0y || l0uv || l1y || l1uv) && count) {
+
+		if (l0y) {
+			l0y = hw->pfnReadFPGARegister(hw->adp,
+				MISC1_Y_RX_FIRST_DESC_L_ADDR_LIST0);
+			l0y &= DMA_START_BIT;
+			if (!l0y)
+				hw->rx_list_sts[0] &= ~rx_waiting_y_intr;
+		}
+
+		if (l1y) {
+			l1y = hw->pfnReadFPGARegister(hw->adp,
+				MISC1_Y_RX_FIRST_DESC_L_ADDR_LIST1);
+			l1y &= DMA_START_BIT;
+			if (!l1y)
+				hw->rx_list_sts[1] &= ~rx_waiting_y_intr;
+		}
+
+		if (l0uv) {
+			l0uv = hw->pfnReadFPGARegister(hw->adp,
+				MISC1_UV_RX_FIRST_DESC_L_ADDR_LIST0);
+			l0uv &= DMA_START_BIT;
+			if (!l0uv)
+				hw->rx_list_sts[0] &= ~rx_waiting_uv_intr;
+		}
+
+		if (l1uv) {
+			l1uv = hw->pfnReadFPGARegister(hw->adp,
+				MISC1_UV_RX_FIRST_DESC_L_ADDR_LIST1);
+			l1uv &= DMA_START_BIT;
+			if (!l1uv)
+				hw->rx_list_sts[1] &= ~rx_waiting_uv_intr;
+		}
+		msleep_interruptible(100);
+		count--;
+	}
+
+	hw->rx_list_post_index = 0;
+
+	dev_dbg(dev, "Capture Stop: %d List0:Sts:%x List1:Sts:%x\n",
+		count, hw->rx_list_sts[0], hw->rx_list_sts[1]);
+}
+
+enum BC_STATUS crystalhd_link_hw_prog_rxdma(struct crystalhd_hw *hw,
+					 struct crystalhd_rx_dma_pkt *rx_pkt)
+{
+	struct device *dev;
+	uint32_t y_low_addr_reg, y_high_addr_reg;
+	uint32_t uv_low_addr_reg, uv_high_addr_reg;
+	addr_64 desc_addr;
+	unsigned long flags;
+
+	if (!hw || !rx_pkt) {
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
+		return BC_STS_INV_ARG;
+	}
+
+	dev = &hw->adp->pdev->dev;
+
+	if (hw->rx_list_post_index >= DMA_ENGINE_CNT) {
+		dev_err(dev, "List Out Of bounds %x\n", hw->rx_list_post_index);
+		return BC_STS_INV_ARG;
+	}
+
+	spin_lock_irqsave(&hw->rx_lock, flags);
+	if (hw->rx_list_sts[hw->rx_list_post_index]) {
+		spin_unlock_irqrestore(&hw->rx_lock, flags);
+		return BC_STS_BUSY;
+	}
+
+	if (!hw->rx_list_post_index) {
+		y_low_addr_reg   = MISC1_Y_RX_FIRST_DESC_L_ADDR_LIST0;
+		y_high_addr_reg  = MISC1_Y_RX_FIRST_DESC_U_ADDR_LIST0;
+		uv_low_addr_reg  = MISC1_UV_RX_FIRST_DESC_L_ADDR_LIST0;
+		uv_high_addr_reg = MISC1_UV_RX_FIRST_DESC_U_ADDR_LIST0;
+	} else {
+		y_low_addr_reg   = MISC1_Y_RX_FIRST_DESC_L_ADDR_LIST1;
+		y_high_addr_reg  = MISC1_Y_RX_FIRST_DESC_U_ADDR_LIST1;
+		uv_low_addr_reg  = MISC1_UV_RX_FIRST_DESC_L_ADDR_LIST1;
+		uv_high_addr_reg = MISC1_UV_RX_FIRST_DESC_U_ADDR_LIST1;
+	}
+	rx_pkt->pkt_tag = hw->rx_pkt_tag_seed + hw->rx_list_post_index;
+	hw->rx_list_sts[hw->rx_list_post_index] |= rx_waiting_y_intr;
+	if (rx_pkt->uv_phy_addr)
+		hw->rx_list_sts[hw->rx_list_post_index] |= rx_waiting_uv_intr;
+	hw->rx_list_post_index = (hw->rx_list_post_index + 1) % DMA_ENGINE_CNT;
+
+	crystalhd_dioq_add(hw->rx_actq, (void *)rx_pkt, false, rx_pkt->pkt_tag);
+
+	crystalhd_link_start_rx_dma_engine(hw);
+	/* Program the Y descriptor */
+	desc_addr.full_addr = rx_pkt->desc_mem.phy_addr;
+	hw->pfnWriteFPGARegister(hw->adp, y_high_addr_reg, desc_addr.high_part);
+	hw->pfnWriteFPGARegister(hw->adp, y_low_addr_reg, desc_addr.low_part | 0x01);
+
+	if (rx_pkt->uv_phy_addr) {
+		/* Program the UV descriptor */
+		desc_addr.full_addr = rx_pkt->uv_phy_addr;
+		hw->pfnWriteFPGARegister(hw->adp, uv_high_addr_reg, desc_addr.high_part);
+		hw->pfnWriteFPGARegister(hw->adp, uv_low_addr_reg, desc_addr.low_part | 0x01);
+	}
+
+	spin_unlock_irqrestore(&hw->rx_lock, flags);
+
+	return BC_STS_SUCCESS;
+}
+
+enum BC_STATUS crystalhd_link_hw_post_cap_buff(struct crystalhd_hw *hw,
+					  struct crystalhd_rx_dma_pkt *rx_pkt)
+{
+	enum BC_STATUS sts = crystalhd_link_hw_prog_rxdma(hw, rx_pkt);
+
+	if (sts == BC_STS_BUSY)
+		crystalhd_dioq_add(hw->rx_freeq, (void *)rx_pkt,
+				 false, rx_pkt->pkt_tag);
+
+	return sts;
+}
+
+void crystalhd_link_get_dnsz(struct crystalhd_hw *hw, uint32_t list_index,
+			     uint32_t *y_dw_dnsz, uint32_t *uv_dw_dnsz)
+{
+	uint32_t y_dn_sz_reg, uv_dn_sz_reg;
+
+	if (!list_index) {
+		y_dn_sz_reg  = MISC1_Y_RX_LIST0_CUR_BYTE_CNT;
+		uv_dn_sz_reg = MISC1_UV_RX_LIST0_CUR_BYTE_CNT;
+	} else {
+		y_dn_sz_reg  = MISC1_Y_RX_LIST1_CUR_BYTE_CNT;
+		uv_dn_sz_reg = MISC1_UV_RX_LIST1_CUR_BYTE_CNT;
+	}
+
+	*y_dw_dnsz  = hw->pfnReadFPGARegister(hw->adp, y_dn_sz_reg);
+	*uv_dw_dnsz = hw->pfnReadFPGARegister(hw->adp, uv_dn_sz_reg);
+}
+
+/*
+ * This function should be called only after making sure that the two DMA
+ * lists are free. This function does not check if DMA's are active, before
+ * turning off the DMA.
+ */
+void crystalhd_link_hw_finalize_pause(struct crystalhd_hw *hw)
+{
+	uint32_t dma_cntrl;
+
+	hw->stop_pending = 0;
+
+	dma_cntrl = hw->pfnReadFPGARegister(hw->adp, MISC1_Y_RX_SW_DESC_LIST_CTRL_STS);
+	if (dma_cntrl & DMA_START_BIT) {
+		dma_cntrl &= ~DMA_START_BIT;
+		hw->pfnWriteFPGARegister(hw->adp, MISC1_Y_RX_SW_DESC_LIST_CTRL_STS,
+				 dma_cntrl);
+	}
+
+	dma_cntrl = hw->pfnReadFPGARegister(hw->adp, MISC1_UV_RX_SW_DESC_LIST_CTRL_STS);
+	if (dma_cntrl & DMA_START_BIT) {
+		dma_cntrl &= ~DMA_START_BIT;
+		hw->pfnWriteFPGARegister(hw->adp, MISC1_UV_RX_SW_DESC_LIST_CTRL_STS,
+				 dma_cntrl);
+	}
+	hw->rx_list_post_index = 0;
+
+/*	aspm = crystalhd_reg_rd(hw->adp, PCIE_DLL_DATA_LINK_CONTROL); */
+/*	aspm |= ASPM_L1_ENABLE; */
+/*	dev_info(&hw->adp->pdev->dev, "aspm on\n"); */
+/*	crystalhd_reg_wr(hw->adp, PCIE_DLL_DATA_LINK_CONTROL, aspm); */
+}
+
+bool crystalhd_link_rx_list0_handler(struct crystalhd_hw *hw,
+				       uint32_t int_sts,
+				       uint32_t y_err_sts,
+				       uint32_t uv_err_sts)
+{
+	uint32_t tmp;
+	enum list_sts tmp_lsts;
+
+	if (!(y_err_sts & GET_Y0_ERR_MSK) && !(uv_err_sts & GET_UV0_ERR_MSK))
+		return false;
+
+	tmp_lsts = hw->rx_list_sts[0];
+
+	/* Y0 - DMA */
+	tmp = y_err_sts & GET_Y0_ERR_MSK;
+	if (int_sts & INTR_INTR_STATUS_L0_Y_RX_DMA_DONE_INTR_MASK)
+		hw->rx_list_sts[0] &= ~rx_waiting_y_intr;
+
+	if (y_err_sts & MISC1_Y_RX_ERROR_STATUS_RX_L0_UNDERRUN_ERROR_MASK) {
+		hw->rx_list_sts[0] &= ~rx_waiting_y_intr;
+		tmp &= ~MISC1_Y_RX_ERROR_STATUS_RX_L0_UNDERRUN_ERROR_MASK;
+	}
+
+	if (y_err_sts & MISC1_Y_RX_ERROR_STATUS_RX_L0_FIFO_FULL_ERRORS_MASK) {
+		hw->rx_list_sts[0] &= ~rx_y_mask;
+		hw->rx_list_sts[0] |= rx_y_error;
+		tmp &= ~MISC1_Y_RX_ERROR_STATUS_RX_L0_FIFO_FULL_ERRORS_MASK;
+	}
+
+	if (tmp) {
+		hw->rx_list_sts[0] &= ~rx_y_mask;
+		hw->rx_list_sts[0] |= rx_y_error;
+		hw->rx_list_post_index = 0;
+	}
+
+	/* UV0 - DMA */
+	tmp = uv_err_sts & GET_UV0_ERR_MSK;
+	if (int_sts & INTR_INTR_STATUS_L0_UV_RX_DMA_DONE_INTR_MASK)
+		hw->rx_list_sts[0] &= ~rx_waiting_uv_intr;
+
+	if (uv_err_sts & MISC1_UV_RX_ERROR_STATUS_RX_L0_UNDERRUN_ERROR_MASK) {
+		hw->rx_list_sts[0] &= ~rx_waiting_uv_intr;
+		tmp &= ~MISC1_UV_RX_ERROR_STATUS_RX_L0_UNDERRUN_ERROR_MASK;
+	}
+
+	if (uv_err_sts & MISC1_UV_RX_ERROR_STATUS_RX_L0_FIFO_FULL_ERRORS_MASK) {
+		hw->rx_list_sts[0] &= ~rx_uv_mask;
+		hw->rx_list_sts[0] |= rx_uv_error;
+		tmp &= ~MISC1_UV_RX_ERROR_STATUS_RX_L0_FIFO_FULL_ERRORS_MASK;
+	}
+
+	if (tmp) {
+		hw->rx_list_sts[0] &= ~rx_uv_mask;
+		hw->rx_list_sts[0] |= rx_uv_error;
+		hw->rx_list_post_index = 0;
+	}
+
+	if (y_err_sts & GET_Y0_ERR_MSK) {
+		tmp = y_err_sts & GET_Y0_ERR_MSK;
+		hw->pfnWriteFPGARegister(hw->adp, MISC1_Y_RX_ERROR_STATUS, tmp);
+	}
+
+	if (uv_err_sts & GET_UV0_ERR_MSK) {
+		tmp = uv_err_sts & GET_UV0_ERR_MSK;
+		hw->pfnWriteFPGARegister(hw->adp, MISC1_UV_RX_ERROR_STATUS, tmp);
+	}
+
+	return (tmp_lsts != hw->rx_list_sts[0]);
+}
+
+bool crystalhd_link_rx_list1_handler(struct crystalhd_hw *hw,
+				       uint32_t int_sts, uint32_t y_err_sts,
+				       uint32_t uv_err_sts)
+{
+	uint32_t tmp;
+	enum list_sts tmp_lsts;
+
+	if (!(y_err_sts & GET_Y1_ERR_MSK) && !(uv_err_sts & GET_UV1_ERR_MSK))
+		return false;
+
+	tmp_lsts = hw->rx_list_sts[1];
+
+	/* Y1 - DMA */
+	tmp = y_err_sts & GET_Y1_ERR_MSK;
+	if (int_sts & INTR_INTR_STATUS_L1_Y_RX_DMA_DONE_INTR_MASK)
+		hw->rx_list_sts[1] &= ~rx_waiting_y_intr;
+
+	if (y_err_sts & MISC1_Y_RX_ERROR_STATUS_RX_L1_UNDERRUN_ERROR_MASK) {
+		hw->rx_list_sts[1] &= ~rx_waiting_y_intr;
+		tmp &= ~MISC1_Y_RX_ERROR_STATUS_RX_L1_UNDERRUN_ERROR_MASK;
+	}
+
+	if (y_err_sts & MISC1_Y_RX_ERROR_STATUS_RX_L1_FIFO_FULL_ERRORS_MASK) {
+		/* Add retry-support..*/
+		hw->rx_list_sts[1] &= ~rx_y_mask;
+		hw->rx_list_sts[1] |= rx_y_error;
+		tmp &= ~MISC1_Y_RX_ERROR_STATUS_RX_L1_FIFO_FULL_ERRORS_MASK;
+	}
+
+	if (tmp) {
+		hw->rx_list_sts[1] &= ~rx_y_mask;
+		hw->rx_list_sts[1] |= rx_y_error;
+		hw->rx_list_post_index = 0;
+	}
+
+	/* UV1 - DMA */
+	tmp = uv_err_sts & GET_UV1_ERR_MSK;
+	if (int_sts & INTR_INTR_STATUS_L1_UV_RX_DMA_DONE_INTR_MASK)
+		hw->rx_list_sts[1] &= ~rx_waiting_uv_intr;
+
+	if (uv_err_sts & MISC1_UV_RX_ERROR_STATUS_RX_L1_UNDERRUN_ERROR_MASK) {
+		hw->rx_list_sts[1] &= ~rx_waiting_uv_intr;
+		tmp &= ~MISC1_UV_RX_ERROR_STATUS_RX_L1_UNDERRUN_ERROR_MASK;
+	}
+
+	if (uv_err_sts & MISC1_UV_RX_ERROR_STATUS_RX_L1_FIFO_FULL_ERRORS_MASK) {
+		/* Add retry-support*/
+		hw->rx_list_sts[1] &= ~rx_uv_mask;
+		hw->rx_list_sts[1] |= rx_uv_error;
+		tmp &= ~MISC1_UV_RX_ERROR_STATUS_RX_L1_FIFO_FULL_ERRORS_MASK;
+	}
+
+	if (tmp) {
+		hw->rx_list_sts[1] &= ~rx_uv_mask;
+		hw->rx_list_sts[1] |= rx_uv_error;
+		hw->rx_list_post_index = 0;
+	}
+
+	if (y_err_sts & GET_Y1_ERR_MSK) {
+		tmp = y_err_sts & GET_Y1_ERR_MSK;
+		hw->pfnWriteFPGARegister(hw->adp, MISC1_Y_RX_ERROR_STATUS, tmp);
+	}
+
+	if (uv_err_sts & GET_UV1_ERR_MSK) {
+		tmp = uv_err_sts & GET_UV1_ERR_MSK;
+		hw->pfnWriteFPGARegister(hw->adp, MISC1_UV_RX_ERROR_STATUS, tmp);
+	}
+
+	return (tmp_lsts != hw->rx_list_sts[1]);
+}
+
+void crystalhd_link_rx_isr(struct crystalhd_hw *hw, uint32_t intr_sts)
+{
+	unsigned long flags;
+	uint32_t i, list_avail = 0;
+	enum BC_STATUS comp_sts = BC_STS_NO_DATA;
+	uint32_t y_err_sts, uv_err_sts, y_dn_sz = 0, uv_dn_sz = 0;
+	bool ret = 0;
+
+	if (!hw) {
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
+		return;
+	}
+
+	if (!(intr_sts & GET_RX_INTR_MASK))
+		return;
+
+	y_err_sts = hw->pfnReadFPGARegister(hw->adp, MISC1_Y_RX_ERROR_STATUS);
+	uv_err_sts = hw->pfnReadFPGARegister(hw->adp, MISC1_UV_RX_ERROR_STATUS);
+
+	for (i = 0; i < DMA_ENGINE_CNT; i++) {
+		/* Update States..*/
+		spin_lock_irqsave(&hw->rx_lock, flags);
+		if (i == 0)
+			ret = crystalhd_link_rx_list0_handler(hw, intr_sts, y_err_sts, uv_err_sts);
+		else
+			ret = crystalhd_link_rx_list1_handler(hw, intr_sts, y_err_sts, uv_err_sts);
+		if (ret) {
+			switch (hw->rx_list_sts[i]) {
+			case sts_free:
+				comp_sts = BC_STS_SUCCESS;
+				list_avail = 1;
+				hw->stats.rx_success++;
+				break;
+			case rx_y_error:
+			case rx_uv_error:
+			case rx_sts_error:
+				/* We got error on both or Y or uv. */
+				hw->stats.rx_errors++;
+				hw->pfnHWGetDoneSize(hw, i, &y_dn_sz, &uv_dn_sz);
+				dev_info(&hw->adp->pdev->dev, "list_index:%x "
+					"rx[%d] rxtot[%d] Y:%x UV:%x Int:%x YDnSz:%x "
+					"UVDnSz:%x\n", i, hw->stats.rx_errors,
+					hw->stats.rx_errors + hw->stats.rx_success,
+					y_err_sts, uv_err_sts, intr_sts,
+					y_dn_sz, uv_dn_sz);
+				hw->rx_list_sts[i] = sts_free;
+				comp_sts = BC_STS_ERROR;
+				break;
+			default:
+				/* Wait for completion..*/
+				comp_sts = BC_STS_NO_DATA;
+				break;
+			}
+		}
+		spin_unlock_irqrestore(&hw->rx_lock, flags);
+
+		/* handle completion...*/
+		if (comp_sts != BC_STS_NO_DATA) {
+			crystalhd_rx_pkt_done(hw, i, comp_sts);
+			comp_sts = BC_STS_NO_DATA;
+		}
+	}
+
+	if (list_avail) {
+		if (hw->stop_pending) {
+			if ((hw->rx_list_sts[0] == sts_free) &&
+			    (hw->rx_list_sts[1] == sts_free))
+				crystalhd_link_hw_finalize_pause(hw);
+		} else {
+			if(!hw->hw_pause_issued)
+				crystalhd_hw_start_capture(hw);
+		}
+	}
+}
+
+enum BC_STATUS crystalhd_link_hw_pause(struct crystalhd_hw *hw, bool state)
+{
+	uint32_t pause = 0;
+	enum BC_STATUS sts = BC_STS_SUCCESS;
+
+	if(state) {
+		pause = 1;
+		hw->stats.pause_cnt++;
+		hw->stop_pending = 1;
+		hw->pfnWriteDevRegister(hw->adp, HW_PauseMbx, pause);
+
+		if ((hw->rx_list_sts[0] == sts_free) &&
+			(hw->rx_list_sts[1] == sts_free))
+			crystalhd_link_hw_finalize_pause(hw);
+	} else {
+		pause = 0;
+		hw->stop_pending = 0;
+		sts = crystalhd_hw_start_capture(hw);
+		hw->pfnWriteDevRegister(hw->adp, HW_PauseMbx, pause);
+	}
+	return sts;
+}
+
+enum BC_STATUS crystalhd_link_fw_cmd_post_proc(struct crystalhd_hw *hw,
+					  struct BC_FW_CMD *fw_cmd)
+{
+	enum BC_STATUS sts = BC_STS_SUCCESS;
+	struct dec_rsp_channel_start_video *st_rsp = NULL;
+
+	switch (fw_cmd->cmd[0]) {
+	case eCMD_C011_DEC_CHAN_START_VIDEO:
+		st_rsp = (struct dec_rsp_channel_start_video *)fw_cmd->rsp;
+		hw->pib_del_Q_addr = st_rsp->picInfoDeliveryQ;
+		hw->pib_rel_Q_addr = st_rsp->picInfoReleaseQ;
+		dev_dbg(&hw->adp->pdev->dev, "DelQAddr:%x RelQAddr:%x\n",
+		       hw->pib_del_Q_addr, hw->pib_rel_Q_addr);
+		break;
+	case eCMD_C011_INIT:
+		if (!(crystalhd_link_load_firmware_config(hw))) {
+			dev_err(&hw->adp->pdev->dev, "Invalid Params\n");
+			sts = BC_STS_FW_AUTH_FAILED;
+		}
+		break;
+	default:
+		break;
+	}
+	return sts;
+}
+
+enum BC_STATUS crystalhd_link_put_ddr2sleep(struct crystalhd_hw *hw)
+{
+	uint32_t reg;
+	union link_misc_perst_decoder_ctrl rst_cntrl_reg;
+
+	/* Pulse reset pin of 7412 (MISC_PERST_DECODER_CTRL) */
+	rst_cntrl_reg.whole_reg = hw->pfnReadDevRegister(hw->adp, MISC_PERST_DECODER_CTRL);
+
+	rst_cntrl_reg.bcm_7412_rst = 1;
+	hw->pfnWriteDevRegister(hw->adp, MISC_PERST_DECODER_CTRL, rst_cntrl_reg.whole_reg);
+	msleep_interruptible(50);
+
+	rst_cntrl_reg.bcm_7412_rst = 0;
+	hw->pfnWriteDevRegister(hw->adp, MISC_PERST_DECODER_CTRL, rst_cntrl_reg.whole_reg);
+
+	/* Close all banks, put DDR in idle */
+	hw->pfnWriteDevRegister(hw->adp, SDRAM_PRECHARGE, 0);
+
+	/* Set bit 25 (drop CKE pin of DDR) */
+	reg = hw->pfnReadDevRegister(hw->adp, SDRAM_PARAM);
+	reg |= 0x02000000;
+	hw->pfnWriteDevRegister(hw->adp, SDRAM_PARAM, reg);
+
+	/* Reset the audio block */
+	hw->pfnWriteDevRegister(hw->adp, AUD_DSP_MISC_SOFT_RESET, 0x1);
+
+	/* Power down Raptor PLL */
+	reg = hw->pfnReadDevRegister(hw->adp, DecHt_PllCCtl);
+	reg |= 0x00008000;
+	hw->pfnWriteDevRegister(hw->adp, DecHt_PllCCtl, reg);
+
+	/* Power down all Audio PLL */
+	hw->pfnWriteDevRegister(hw->adp, AIO_MISC_PLL_RESET, 0x1);
+
+	/* Power down video clock (75MHz) */
+	reg = hw->pfnReadDevRegister(hw->adp, DecHt_PllECtl);
+	reg |= 0x00008000;
+	hw->pfnWriteDevRegister(hw->adp, DecHt_PllECtl, reg);
+
+	/* Power down video clock (75MHz) */
+	reg = hw->pfnReadDevRegister(hw->adp, DecHt_PllDCtl);
+	reg |= 0x00008000;
+	hw->pfnWriteDevRegister(hw->adp, DecHt_PllDCtl, reg);
+
+	/* Power down core clock (200MHz) */
+	reg = hw->pfnReadDevRegister(hw->adp, DecHt_PllACtl);
+	reg |= 0x00008000;
+	hw->pfnWriteDevRegister(hw->adp, DecHt_PllACtl, reg);
+
+	/* Power down core clock (200MHz) */
+	reg = hw->pfnReadDevRegister(hw->adp, DecHt_PllBCtl);
+	reg |= 0x00008000;
+	hw->pfnWriteDevRegister(hw->adp, DecHt_PllBCtl, reg);
+
+	return BC_STS_SUCCESS;
+}
+
+/************************************************
+**
+*************************************************/
+
+enum BC_STATUS crystalhd_link_download_fw(struct crystalhd_hw *hw,
+				uint8_t *buffer, uint32_t sz)
+{
+	struct device *dev;
+	uint32_t reg_data, cnt, *temp_buff;
+	uint32_t fw_sig_len = 36;
+	uint32_t dram_offset = BC_FWIMG_ST_ADDR, sig_reg;
+
+	if (!hw || !buffer || !sz) {
+		printk(KERN_ERR "%s: Invalid Params\n", __func__);
+		return BC_STS_INV_ARG;
+	}
+
+	dev = &hw->adp->pdev->dev;
+
+	dev_dbg(dev, "%s entered\n", __func__);
+
+	reg_data = hw->pfnReadFPGARegister(hw->adp, OTP_CMD);
+	if (!(reg_data & 0x02)) {
+		dev_err(dev, "Invalid hw config.. otp not programmed\n");
+		return BC_STS_ERROR;
+	}
+
+	reg_data = 0;
+	hw->pfnWriteFPGARegister(hw->adp, DCI_CMD, 0);
+	reg_data |= BC_BIT(0);
+	hw->pfnWriteFPGARegister(hw->adp, DCI_CMD, reg_data);
+
+	reg_data = 0;
+	cnt = 1000;
+	msleep_interruptible(10);
+
+	while (reg_data != BC_BIT(4)) {
+		reg_data = hw->pfnReadFPGARegister(hw->adp, DCI_STATUS);
+		reg_data &= BC_BIT(4);
+		if (--cnt == 0) {
+			dev_err(dev, "Firmware Download RDY Timeout.\n");
+			return BC_STS_TIMEOUT;
+		}
+	}
+
+	msleep_interruptible(10);
+	/*  Load the FW to the FW_ADDR field in the DCI_FIRMWARE_ADDR */
+	hw->pfnWriteFPGARegister(hw->adp, DCI_FIRMWARE_ADDR, dram_offset);
+	temp_buff = (uint32_t *)buffer;
+	for (cnt = 0; cnt < (sz - fw_sig_len); cnt += 4) {
+		hw->pfnWriteFPGARegister(hw->adp, DCI_DRAM_BASE_ADDR, (dram_offset >> 19));
+		hw->pfnWriteFPGARegister(hw->adp, DCI_FIRMWARE_DATA, *temp_buff);
+		dram_offset += 4;
+		temp_buff++;
+	}
+	msleep_interruptible(10);
+
+	temp_buff++;
+
+	sig_reg = (uint32_t)DCI_SIGNATURE_DATA_7;
+	for (cnt = 0; cnt < 8; cnt++) {
+		uint32_t swapped_data = *temp_buff;
+		swapped_data = cpu_to_be32(swapped_data);
+		hw->pfnWriteFPGARegister(hw->adp, sig_reg, swapped_data);
+		sig_reg -= 4;
+		temp_buff++;
+	}
+	msleep_interruptible(10);
+
+	reg_data = 0;
+	reg_data |= BC_BIT(1);
+	hw->pfnWriteFPGARegister(hw->adp, DCI_CMD, reg_data);
+	msleep_interruptible(10);
+
+	reg_data = 0;
+	reg_data = hw->pfnReadFPGARegister(hw->adp, DCI_STATUS);
+
+	if ((reg_data & BC_BIT(9)) == BC_BIT(9)) {
+		cnt = 1000;
+		while ((reg_data & BC_BIT(0)) != BC_BIT(0)) {
+			reg_data = hw->pfnReadFPGARegister(hw->adp, DCI_STATUS);
+			reg_data &= BC_BIT(0);
+			if (!(--cnt))
+				break;
+			msleep_interruptible(10);
+		}
+		reg_data = 0;
+		reg_data = hw->pfnReadFPGARegister(hw->adp, DCI_CMD);
+		reg_data |= BC_BIT(4);
+		hw->pfnWriteFPGARegister(hw->adp, DCI_CMD, reg_data);
+
+	} else {
+		dev_err(dev, "F/w Signature mismatch\n");
+		return BC_STS_FW_AUTH_FAILED;
+	}
+
+	dev_dbg(dev, "Firmware Downloaded Successfully\n");
+
+	/* Load command response addresses */
+	hw->fwcmdPostAddr = TS_Host2CpuSnd;
+	hw->fwcmdPostMbox = Hst2CpuMbx1;
+	hw->fwcmdRespMbox = Cpu2HstMbx1;
+
+	return BC_STS_SUCCESS;;
+}
+
+enum BC_STATUS crystalhd_link_do_fw_cmd(struct crystalhd_hw *hw, struct BC_FW_CMD *fw_cmd)
+{
+	struct device *dev;
+	uint32_t cnt = 0, cmd_res_addr;
+	uint32_t *cmd_buff, *res_buff;
+	wait_queue_head_t fw_cmd_event;
+	int rc = 0;
+	enum BC_STATUS sts;
+	unsigned long flags;
+
+	crystalhd_create_event(&fw_cmd_event);
+
+	if (!hw || !fw_cmd) {
+		printk(KERN_ERR "%s: Invalid Arguments\n", __func__);
+		return BC_STS_INV_ARG;
+	}
+
+	dev = &hw->adp->pdev->dev;
+
+	dev_dbg(dev, "%s entered\n", __func__);
+
+	cmd_buff = fw_cmd->cmd;
+	res_buff = fw_cmd->rsp;
+
+	if (!cmd_buff || !res_buff) {
+		dev_err(dev, "Invalid Parameters for F/W Command\n");
+		return BC_STS_INV_ARG;
+	}
+
+	hw->fwcmd_evt_sts = 0;
+	hw->pfw_cmd_event = &fw_cmd_event;
+
+	spin_lock_irqsave(&hw->lock, flags);
+
+	/*Write the command to the memory*/
+	hw->pfnDevDRAMWrite(hw, hw->fwcmdPostAddr, FW_CMD_BUFF_SZ, cmd_buff);
+
+	/*Memory Read for memory arbitrator flush*/
+	hw->pfnDevDRAMRead(hw, hw->fwcmdPostAddr, 1, &cnt);
+
+	/* Write the command address to mailbox */
+	hw->pfnWriteDevRegister(hw->adp, hw->fwcmdPostMbox, hw->fwcmdPostAddr);
+
+	spin_unlock_irqrestore(&hw->lock, flags);
+
+	msleep_interruptible(50);
+
+	/* FW commands should complete even if we got a signal from the upper layer */
+	crystalhd_wait_on_event(&fw_cmd_event, hw->fwcmd_evt_sts,
+				20000, rc, true);
+
+	if (!rc) {
+		sts = BC_STS_SUCCESS;
+	} else if (rc == -EBUSY) {
+		dev_err(dev, "Firmware command T/O\n");
+		sts = BC_STS_TIMEOUT;
+	} else if (rc == -EINTR) {
+		dev_err(dev, "FwCmd Wait Signal int - Should never happen\n");
+		sts = BC_STS_IO_USER_ABORT;
+	} else {
+		dev_err(dev, "FwCmd IO Error.\n");
+		sts = BC_STS_IO_ERROR;
+	}
+
+	if (sts != BC_STS_SUCCESS) {
+		dev_err(dev, "FwCmd Failed.\n");
+		return sts;
+	}
+
+	spin_lock_irqsave(&hw->lock, flags);
+
+	/*Get the Responce Address*/
+	cmd_res_addr = hw->pfnReadDevRegister(hw->adp, hw->fwcmdRespMbox);
+
+	/*Read the Response*/
+	hw->pfnDevDRAMRead(hw, cmd_res_addr, FW_CMD_BUFF_SZ, res_buff);
+
+	spin_unlock_irqrestore(&hw->lock, flags);
+
+	if (res_buff[2] != C011_RET_SUCCESS) {
+		dev_err(dev, "res_buff[2] != C011_RET_SUCCESS\n");
+		return BC_STS_FW_CMD_ERR;
+	}
+
+	sts = crystalhd_link_fw_cmd_post_proc(hw, fw_cmd);
+	if (sts != BC_STS_SUCCESS)
+		dev_err(dev, "crystalhd_fw_cmd_post_proc Failed.\n");
+
+	return sts;
+}
+
+bool crystalhd_link_hw_interrupt_handle(struct crystalhd_adp *adp, struct crystalhd_hw *hw)
+{
+	uint32_t intr_sts = 0;
+	uint32_t deco_intr = 0;
+	bool rc = false;
+
+	if (!adp || !hw->dev_started)
+		return rc;
+
+	hw->stats.num_interrupts++;
+
+	deco_intr = hw->pfnReadDevRegister(hw->adp, Stream2Host_Intr_Sts);
+	intr_sts  = hw->pfnReadFPGARegister(hw->adp, INTR_INTR_STATUS);
+
+	if (intr_sts) {
+		/* let system know we processed interrupt..*/
+		rc = true;
+		hw->stats.dev_interrupts++;
+	}
+
+	if (deco_intr && (deco_intr != 0xdeaddead)) {
+
+		if (deco_intr & 0x80000000) {
+			/*Set the Event and the status flag*/
+			if (hw->pfw_cmd_event) {
+				hw->fwcmd_evt_sts = 1;
+				crystalhd_set_event(hw->pfw_cmd_event);
+			}
+		}
+
+		if (deco_intr & BC_BIT(1))
+			crystalhd_link_proc_pib(hw);
+
+		hw->pfnWriteDevRegister(hw->adp, Stream2Host_Intr_Sts, deco_intr);
+		hw->pfnWriteDevRegister(hw->adp, Stream2Host_Intr_Sts, 0);
+		rc = 1;
+	}
+
+	/* Rx interrupts */
+	crystalhd_link_rx_isr(hw, intr_sts);
+
+	/* Tx interrupts*/
+	crystalhd_link_tx_isr(hw, intr_sts);
+
+	/* Clear interrupts */
+	if (rc) {
+		if (intr_sts)
+			hw->pfnWriteFPGARegister(hw->adp, INTR_INTR_CLR_REG, intr_sts);
+
+		hw->pfnWriteFPGARegister(hw->adp, INTR_EOI_CTRL, 1);
+	}
+
+	return rc;
+}
+
+/* Dummy private function */
+void crystalhd_link_notify_fll_change(struct crystalhd_hw *hw, bool bCleanupContext)
+{
+	return;
+}
+
+bool crystalhd_link_notify_event(struct crystalhd_hw *hw, enum BRCM_EVENT EventCode)
+{
+	return true;
+}
diff --git a/drivers/staging/crystalhd/crystalhd_linkfuncs.h b/drivers/staging/crystalhd/crystalhd_linkfuncs.h
new file mode 100644
index 0000000..58722ee
--- /dev/null
+++ b/drivers/staging/crystalhd/crystalhd_linkfuncs.h
@@ -0,0 +1,228 @@
+/***************************************************************************
+ * Copyright (c) 2005-2009, Broadcom Corporation.
+ *
+ *  Name: crystalhd_linkfuncs . h
+ *
+ *  Description:
+ *		BCM70012 Linux driver hardware layer.
+ *
+ *  HISTORY:
+ *
+ **********************************************************************
+ * This file is part of the crystalhd device driver.
+ *
+ * This driver is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, version 2 of the License.
+ *
+ * This driver is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this driver.  If not, see <http://www.gnu.org/licenses/>.
+ **********************************************************************/
+
+#ifndef _CRYSTALHD_LINKFUNCS_H_
+#define _CRYSTALHD_LINKFUNCS_H_
+
+#define ASPM_L1_ENABLE		(BC_BIT(27))
+
+/*************************************************
+  7412 Decoder  Registers.
+**************************************************/
+#define FW_CMD_BUFF_SZ		64
+#define TS_Host2CpuSnd		0x00000100
+#define HW_PauseMbx		0x00000300
+#define Hst2CpuMbx1		0x00100F00
+#define Cpu2HstMbx1		0x00100F04
+#define MbxStat1		0x00100F08
+#define Stream2Host_Intr_Sts	0x00100F24
+#define C011_RET_SUCCESS	0x0	/* Reutrn status of firmware command. */
+
+/* TS input status register */
+#define TS_StreamAFIFOStatus	0x0010044C
+#define TS_StreamBFIFOStatus	0x0010084C
+
+/*UART Selection definitions*/
+#define UartSelectA		0x00100300
+#define UartSelectB		0x00100304
+
+#define BSVS_UART_DEC_NONE	0x00
+#define BSVS_UART_DEC_OUTER	0x01
+#define BSVS_UART_DEC_INNER	0x02
+#define BSVS_UART_STREAM	0x03
+
+/* Code-In fifo */
+#define REG_DecCA_RegCinCTL	0xa00
+#define REG_DecCA_RegCinBase	0xa0c
+#define REG_DecCA_RegCinEnd	0xa10
+#define REG_DecCA_RegCinWrPtr	0xa04
+#define REG_DecCA_RegCinRdPtr	0xa08
+
+#define REG_Dec_TsUser0Base	0x100864
+#define REG_Dec_TsUser0Rdptr	0x100868
+#define REG_Dec_TsUser0Wrptr	0x10086C
+#define REG_Dec_TsUser0End	0x100874
+
+/* ASF Case ...*/
+#define REG_Dec_TsAudCDB2Base	0x10036c
+#define REG_Dec_TsAudCDB2Rdptr  0x100378
+#define REG_Dec_TsAudCDB2Wrptr  0x100374
+#define REG_Dec_TsAudCDB2End	0x100370
+
+/* DRAM bringup Registers */
+#define SDRAM_PARAM		0x00040804
+#define SDRAM_PRECHARGE		0x000408B0
+#define SDRAM_EXT_MODE		0x000408A4
+#define SDRAM_MODE		0x000408A0
+#define SDRAM_REFRESH		0x00040890
+#define SDRAM_REF_PARAM		0x00040808
+
+#define DecHt_PllACtl		0x34000C
+#define DecHt_PllBCtl		0x340010
+#define DecHt_PllCCtl		0x340014
+#define DecHt_PllDCtl		0x340034
+#define DecHt_PllECtl		0x340038
+#define AUD_DSP_MISC_SOFT_RESET	0x00240104
+#define AIO_MISC_PLL_RESET	0x0026000C
+#define PCIE_CLK_REQ_REG	0xDC
+#define	PCI_CLK_REQ_ENABLE	(BC_BIT(8))
+
+/*************************************************
+  F/W Copy engine definitions..
+**************************************************/
+#define BC_FWIMG_ST_ADDR	0x00000000
+
+#define DecHt_HostSwReset	0x340000
+#define BC_DRAM_FW_CFG_ADDR	0x001c2000
+
+union intr_mask_reg {
+	struct {
+		uint32_t	mask_tx_done:1;
+		uint32_t	mask_tx_err:1;
+		uint32_t	mask_rx_done:1;
+		uint32_t	mask_rx_err:1;
+		uint32_t	mask_pcie_err:1;
+		uint32_t	mask_pcie_rbusmast_err:1;
+		uint32_t	mask_pcie_rgr_bridge:1;
+		uint32_t	reserved:25;
+	};
+
+	uint32_t	whole_reg;
+
+};
+
+union link_misc_perst_deco_ctrl {
+	struct {
+		uint32_t	bcm7412_rst:1;		/* 1 -> BCM7412 is held in reset. Reset value 1.*/
+		uint32_t	reserved0:3;		/* Reserved.No Effect*/
+		uint32_t	stop_bcm_7412_clk:1;	/* 1 ->Stops branch of 27MHz clk used to clk BCM7412*/
+		uint32_t	reserved1:27;		/* Reseved. No Effect*/
+	};
+
+	uint32_t	whole_reg;
+
+};
+
+union link_misc_perst_clk_ctrl {
+	struct {
+		uint32_t	sel_alt_clk:1;	  /* When set, selects a 6.75MHz clock as the source of core_clk */
+		uint32_t	stop_core_clk:1;  /* When set, stops the branch of core_clk that is not needed for low power operation */
+		uint32_t	pll_pwr_dn:1;	  /* When set, powers down the main PLL. The alternate clock bit should be set
+						     to select an alternate clock before setting this bit.*/
+		uint32_t	reserved0:5;	  /* Reserved */
+		uint32_t	pll_mult:8;	  /* This setting controls the multiplier for the PLL. */
+		uint32_t	pll_div:4;	  /* This setting controls the divider for the PLL. */
+		uint32_t	reserved1:12;	  /* Reserved */
+	};
+
+	uint32_t	whole_reg;
+
+};
+
+
+union link_misc_perst_decoder_ctrl {
+	struct {
+		uint32_t	bcm_7412_rst:1; /* 1 -> BCM7412 is held in reset. Reset value 1.*/
+		uint32_t	res0:3; /* Reserved.No Effect*/
+		uint32_t	stop_7412_clk:1; /* 1 ->Stops branch of 27MHz clk used to clk BCM7412*/
+		uint32_t	res1:27; /* Reseved. No Effect */
+	};
+
+	uint32_t	whole_reg;
+
+};
+
+/* DMA engine register BIT mask wrappers.. */
+#define DMA_START_BIT		MISC1_TX_SW_DESC_LIST_CTRL_STS_TX_DMA_RUN_STOP_MASK
+
+#define GET_RX_INTR_MASK (INTR_INTR_STATUS_L1_UV_RX_DMA_ERR_INTR_MASK |		\
+			  INTR_INTR_STATUS_L1_UV_RX_DMA_DONE_INTR_MASK |	\
+			  INTR_INTR_STATUS_L1_Y_RX_DMA_ERR_INTR_MASK |		\
+			  INTR_INTR_STATUS_L1_Y_RX_DMA_DONE_INTR_MASK |		\
+			  INTR_INTR_STATUS_L0_UV_RX_DMA_ERR_INTR_MASK |		\
+			  INTR_INTR_STATUS_L0_UV_RX_DMA_DONE_INTR_MASK |	\
+			  INTR_INTR_STATUS_L0_Y_RX_DMA_ERR_INTR_MASK |		\
+			  INTR_INTR_STATUS_L0_Y_RX_DMA_DONE_INTR_MASK)
+
+uint32_t link_dec_reg_rd(struct crystalhd_adp *adp, uint32_t reg_off);
+void link_dec_reg_wr(struct crystalhd_adp *adp, uint32_t reg_off, uint32_t val);
+uint32_t crystalhd_link_reg_rd(struct crystalhd_adp *adp, uint32_t reg_off);
+void crystalhd_link_reg_wr(struct crystalhd_adp *adp, uint32_t reg_off, uint32_t val);
+uint32_t crystalhd_link_dram_rd(struct crystalhd_hw *hw, uint32_t mem_off);
+void crystalhd_link_dram_wr(struct crystalhd_hw *hw, uint32_t mem_off, uint32_t val);
+enum BC_STATUS crystalhd_link_mem_rd(struct crystalhd_hw *hw, uint32_t start_off, uint32_t dw_cnt, uint32_t *rd_buff);
+enum BC_STATUS crystalhd_link_mem_wr(struct crystalhd_hw *hw, uint32_t start_off, uint32_t dw_cnt, uint32_t *wr_buff);
+void crystalhd_link_enable_uarts(struct crystalhd_hw *hw);
+void crystalhd_link_start_dram(struct crystalhd_hw *hw);
+bool crystalhd_link_bring_out_of_rst(struct crystalhd_hw *hw);
+bool crystalhd_link_put_in_reset(struct crystalhd_hw *hw);
+void crystalhd_link_disable_interrupts(struct crystalhd_hw *hw);
+void crystalhd_link_enable_interrupts(struct crystalhd_hw *hw);
+void crystalhd_link_clear_errors(struct crystalhd_hw *hw);
+void crystalhd_link_clear_interrupts(struct crystalhd_hw *hw);
+void crystalhd_link_soft_rst(struct crystalhd_hw *hw);
+bool crystalhd_link_load_firmware_config(struct crystalhd_hw *hw);
+bool crystalhd_link_start_device(struct crystalhd_hw *hw);
+bool crystalhd_link_stop_device(struct crystalhd_hw *hw);
+uint32_t link_GetPicInfoLineNum(struct crystalhd_dio_req *dio, uint8_t *base);
+uint32_t link_GetMode422Data(struct crystalhd_dio_req *dio, struct BC_PIC_INFO_BLOCK *pPicInfoLine, int type);
+uint32_t link_GetMetaDataFromPib(struct crystalhd_dio_req *dio,	struct BC_PIC_INFO_BLOCK *pPicInfoLine);
+uint32_t link_GetHeightFromPib(struct crystalhd_dio_req *dio, struct BC_PIC_INFO_BLOCK *pPicInfoLine);
+bool link_GetPictureInfo(struct crystalhd_hw *hw, uint32_t picHeight, uint32_t picWidth, struct crystalhd_dio_req *dio,
+								uint32_t *PicNumber, uint64_t *PicMetaData);
+uint32_t link_GetRptDropParam(struct crystalhd_hw *hw, uint32_t picHeight, uint32_t picWidth, void *pRxDMAReq);
+bool crystalhd_link_peek_next_decoded_frame(struct crystalhd_hw *hw, uint64_t *meta_payload, uint32_t *picNumFlags, uint32_t PicWidth);
+bool crystalhd_link_check_input_full(struct crystalhd_hw *hw, uint32_t needed_sz, uint32_t *empty_sz,
+									 bool b_188_byte_pkts, uint8_t *flags);
+bool crystalhd_link_tx_list0_handler(struct crystalhd_hw *hw, uint32_t err_sts);
+bool crystalhd_link_tx_list1_handler(struct crystalhd_hw *hw, uint32_t err_sts);
+void crystalhd_link_tx_isr(struct crystalhd_hw *hw, uint32_t int_sts);
+void crystalhd_link_start_tx_dma_engine(struct crystalhd_hw *hw, uint8_t list_id, addr_64 desc_addr);
+enum BC_STATUS crystalhd_link_stop_tx_dma_engine(struct crystalhd_hw *hw);
+uint32_t crystalhd_link_get_pib_avail_cnt(struct crystalhd_hw *hw);
+uint32_t crystalhd_link_get_addr_from_pib_Q(struct crystalhd_hw *hw);
+bool crystalhd_link_rel_addr_to_pib_Q(struct crystalhd_hw *hw, uint32_t addr_to_rel);
+void link_cpy_pib_to_app(struct c011_pib *src_pib, struct BC_PIC_INFO_BLOCK *dst_pib);
+void crystalhd_link_proc_pib(struct crystalhd_hw *hw);
+void crystalhd_link_start_rx_dma_engine(struct crystalhd_hw *hw);
+void crystalhd_link_stop_rx_dma_engine(struct crystalhd_hw *hw);
+enum BC_STATUS crystalhd_link_hw_prog_rxdma(struct crystalhd_hw *hw, struct crystalhd_rx_dma_pkt *rx_pkt);
+enum BC_STATUS crystalhd_link_hw_post_cap_buff(struct crystalhd_hw *hw, struct crystalhd_rx_dma_pkt *rx_pkt);
+void crystalhd_link_get_dnsz(struct crystalhd_hw *hw, uint32_t list_index,
+									uint32_t *y_dw_dnsz, uint32_t *uv_dw_dnsz);
+void crystalhd_link_hw_finalize_pause(struct crystalhd_hw *hw);
+bool crystalhd_link_rx_list0_handler(struct crystalhd_hw *hw,uint32_t int_sts,uint32_t y_err_sts,uint32_t uv_err_sts);
+bool crystalhd_link_rx_list1_handler(struct crystalhd_hw *hw,uint32_t int_sts,uint32_t y_err_sts,uint32_t uv_err_sts);
+void crystalhd_link_rx_isr(struct crystalhd_hw *hw, uint32_t intr_sts);
+enum BC_STATUS crystalhd_link_hw_pause(struct crystalhd_hw *hw, bool state);
+enum BC_STATUS crystalhd_link_fw_cmd_post_proc(struct crystalhd_hw *hw, struct BC_FW_CMD *fw_cmd);
+enum BC_STATUS crystalhd_link_put_ddr2sleep(struct crystalhd_hw *hw);
+enum BC_STATUS crystalhd_link_download_fw(struct crystalhd_hw* hw, uint8_t* buffer, uint32_t sz);
+enum BC_STATUS crystalhd_link_do_fw_cmd(struct crystalhd_hw *hw, struct BC_FW_CMD *fw_cmd);
+bool crystalhd_link_hw_interrupt_handle(struct crystalhd_adp *adp, struct crystalhd_hw *hw);
+void crystalhd_link_notify_fll_change(struct crystalhd_hw *hw, bool bCleanupContext);
+bool crystalhd_link_notify_event(struct crystalhd_hw *hw, enum BRCM_EVENT EventCode);
+#endif
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
index b17fbf8..0e48741 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.c
+++ b/drivers/staging/crystalhd/crystalhd_lnx.c
@@ -26,6 +26,14 @@ static struct class *crystalhd_class;
 
 static struct crystalhd_adp *g_adp_info;
 
+extern int bc_get_userhandle_count(struct crystalhd_cmd *ctx);
+
+struct device *chddev(void)
+{
+	return &g_adp_info->pdev->dev;
+}
+
+
 static irqreturn_t chd_dec_isr(int irq, void *arg)
 {
 	struct crystalhd_adp *adp = (struct crystalhd_adp *) arg;
@@ -41,20 +49,25 @@ static int chd_dec_enable_int(struct crystalhd_adp *adp)
 	int rc = 0;
 
 	if (!adp || !adp->pdev) {
-		BCMLOG_ERR("Invalid arg!!\n");
+		printk(KERN_ERR "%s: Invalid arg\n", __func__);
 		return -EINVAL;
 	}
 
-	if (adp->pdev->msi_enabled)
-		adp->msi = 1;
+	rc = pci_enable_msi(adp->pdev);
+	if(rc != 0)
+		dev_err(&adp->pdev->dev, "MSI request failed..\n");
 	else
-		adp->msi = pci_enable_msi(adp->pdev);
+		adp->msi = 1;
 
 	rc = request_irq(adp->pdev->irq, chd_dec_isr, IRQF_SHARED,
 			 adp->name, (void *)adp);
-	if (rc) {
-		BCMLOG_ERR("Interrupt request failed..\n");
-		pci_disable_msi(adp->pdev);
+
+	if (rc != 0) {
+		dev_err(&adp->pdev->dev, "Interrupt request failed..\n");
+		if(adp->msi) {
+			pci_disable_msi(adp->pdev);
+			adp->msi = 0;
+		}
 	}
 
 	return rc;
@@ -63,14 +76,16 @@ static int chd_dec_enable_int(struct crystalhd_adp *adp)
 static int chd_dec_disable_int(struct crystalhd_adp *adp)
 {
 	if (!adp || !adp->pdev) {
-		BCMLOG_ERR("Invalid arg!!\n");
+		printk(KERN_ERR "%s: Invalid arg\n", __func__);
 		return -EINVAL;
 	}
 
 	free_irq(adp->pdev->irq, adp);
 
-	if (adp->msi)
+	if (adp->msi) {
 		pci_disable_msi(adp->pdev);
+		adp->msi = 0;
+	}
 
 	return 0;
 }
@@ -116,7 +131,7 @@ static inline int crystalhd_user_data(unsigned long ud, void *dr,
 	int rc;
 
 	if (!ud || !dr) {
-		BCMLOG_ERR("Invalid arg\n");
+		dev_err(chddev(), "%s: Invalid arg\n", __func__);
 		return -EINVAL;
 	}
 
@@ -126,7 +141,7 @@ static inline int crystalhd_user_data(unsigned long ud, void *dr,
 		rc = copy_from_user(dr, (void *)ud, size);
 
 	if (rc) {
-		BCMLOG_ERR("Invalid args for command\n");
+		dev_err(chddev(), "Invalid args for command\n");
 		rc = -EFAULT;
 	}
 
@@ -140,13 +155,13 @@ static int chd_dec_fetch_cdata(struct crystalhd_adp *adp,
 	int rc = 0;
 
 	if (!adp || !io || !ua || !m_sz) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		dev_err(chddev(), "Invalid Arg!!\n");
 		return -EINVAL;
 	}
 
 	io->add_cdata = vmalloc(m_sz);
 	if (!io->add_cdata) {
-		BCMLOG_ERR("kalloc fail for sz:%x\n", m_sz);
+		dev_err(chddev(), "kalloc fail for sz:%x\n", m_sz);
 		return -ENOMEM;
 	}
 
@@ -154,8 +169,9 @@ static int chd_dec_fetch_cdata(struct crystalhd_adp *adp,
 	ua_off = ua + sizeof(io->udata);
 	rc = crystalhd_user_data(ua_off, io->add_cdata, io->add_cdata_sz, 0);
 	if (rc) {
-		BCMLOG_ERR("failed to pull add_cdata sz:%x ua_off:%x\n",
-			   io->add_cdata_sz, (unsigned int)ua_off);
+		dev_err(chddev(), "failed to pull add_cdata sz:%x "
+			"ua_off:%x\n", io->add_cdata_sz,
+			(unsigned int)ua_off);
 		kfree(io->add_cdata);
 		io->add_cdata = NULL;
 		return -ENODATA;
@@ -171,7 +187,7 @@ static int chd_dec_release_cdata(struct crystalhd_adp *adp,
 	int rc;
 
 	if (!adp || !io || !ua) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		dev_err(chddev(), "Invalid Arg!!\n");
 		return -EINVAL;
 	}
 
@@ -180,9 +196,9 @@ static int chd_dec_release_cdata(struct crystalhd_adp *adp,
 		rc = crystalhd_user_data(ua_off, io->add_cdata,
 					io->add_cdata_sz, 1);
 		if (rc) {
-			BCMLOG_ERR(
-				"failed to push add_cdata sz:%x ua_off:%x\n",
-				 io->add_cdata_sz, (unsigned int)ua_off);
+			dev_err(chddev(), "failed to push add_cdata sz:%x "
+				"ua_off:%x\n", io->add_cdata_sz,
+				(unsigned int)ua_off);
 			return -ENODATA;
 		}
 	}
@@ -203,13 +219,14 @@ static int chd_dec_proc_user_data(struct crystalhd_adp *adp,
 	uint32_t m_sz = 0;
 
 	if (!adp || !io || !ua) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		dev_err(chddev(), "Invalid Arg!!\n");
 		return -EINVAL;
 	}
 
 	rc = crystalhd_user_data(ua, &io->udata, sizeof(io->udata), set);
 	if (rc) {
-		BCMLOG_ERR("failed to %s iodata\n", (set ? "set" : "get"));
+		dev_err(chddev(), "failed to %s iodata\n",
+			(set ? "set" : "get"));
 		return rc;
 	}
 
@@ -239,7 +256,7 @@ static int chd_dec_api_cmd(struct crystalhd_adp *adp, unsigned long ua,
 
 	temp = chd_dec_alloc_iodata(adp, 0);
 	if (!temp) {
-		BCMLOG_ERR("Failed to get iodata..\n");
+		dev_err(chddev(), "Failed to get iodata..\n");
 		return -EINVAL;
 	}
 
@@ -248,7 +265,10 @@ static int chd_dec_api_cmd(struct crystalhd_adp *adp, unsigned long ua,
 
 	rc = chd_dec_proc_user_data(adp, temp, ua, 0);
 	if (!rc) {
-		sts = func(&adp->cmds, temp);
+		if(func == NULL)
+			sts = BC_STS_PWR_MGMT; /* Can only happen when we are in suspend state */
+		else
+			sts = func(&adp->cmds, temp);
 		if (sts == BC_STS_PENDING)
 			sts = BC_STS_NOT_IMPL;
 		temp->udata.RetSts = sts;
@@ -264,25 +284,28 @@ static int chd_dec_api_cmd(struct crystalhd_adp *adp, unsigned long ua,
 static long chd_dec_ioctl(struct file *fd, unsigned int cmd, unsigned long ua)
 {
 	struct crystalhd_adp *adp = chd_get_adp();
+	struct device *dev = &adp->pdev->dev;
 	crystalhd_cmd_proc cproc;
 	struct crystalhd_user *uc;
 	int ret;
 
+	dev_dbg(dev, "Entering %s\n", __func__);
+
 	if (!adp || !fd) {
-		BCMLOG_ERR("Invalid adp\n");
+		dev_err(chddev(), "Invalid adp\n");
 		return -EINVAL;
 	}
 
 	uc = fd->private_data;
 	if (!uc) {
-		BCMLOG_ERR("Failed to get uc\n");
+		dev_err(chddev(), "Failed to get uc\n");
 		return -ENODATA;
 	}
 
 	mutex_lock(&chd_dec_mutex);
 	cproc = crystalhd_get_cmd_proc(&adp->cmds, cmd, uc);
-	if (!cproc) {
-		BCMLOG_ERR("Unhandled command: %d\n", cmd);
+	if (!cproc && !(adp->cmds.state & BC_LINK_SUSPEND)) {
+		dev_err(chddev(), "Unhandled command: %d\n", cmd);
 		mutex_unlock(&chd_dec_mutex);
 		return -EINVAL;
 	}
@@ -295,29 +318,32 @@ static long chd_dec_ioctl(struct file *fd, unsigned int cmd, unsigned long ua)
 static int chd_dec_open(struct inode *in, struct file *fd)
 {
 	struct crystalhd_adp *adp = chd_get_adp();
+	struct device *dev = &adp->pdev->dev;
 	int rc = 0;
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 	struct crystalhd_user *uc = NULL;
 
+	dev_dbg(dev, "Entering %s\n", __func__);
+
 	if (!adp) {
-		BCMLOG_ERR("Invalid adp\n");
+		dev_err(dev, "Invalid adp\n");
 		return -EINVAL;
 	}
 
 	if (adp->cfg_users >= BC_LINK_MAX_OPENS) {
-		BCMLOG(BCMLOG_INFO, "Already in use.%d\n", adp->cfg_users);
+		dev_info(dev, "Already in use.%d\n", adp->cfg_users);
 		return -EBUSY;
 	}
 
 	sts = crystalhd_user_open(&adp->cmds, &uc);
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("cmd_user_open - %d\n", sts);
+		dev_err(dev, "cmd_user_open - %d\n", sts);
 		rc = -EBUSY;
 	}
-
-	adp->cfg_users++;
-
-	fd->private_data = uc;
+	else {
+		adp->cfg_users++;
+		fd->private_data = uc;
+	}
 
 	return rc;
 }
@@ -325,38 +351,79 @@ static int chd_dec_open(struct inode *in, struct file *fd)
 static int chd_dec_close(struct inode *in, struct file *fd)
 {
 	struct crystalhd_adp *adp = chd_get_adp();
+	struct device *dev = &adp->pdev->dev;
+	struct crystalhd_cmd *ctx = &adp->cmds;
 	struct crystalhd_user *uc;
+	uint32_t mode;
 
+	dev_dbg(dev, "Entering %s\n", __func__);
 	if (!adp) {
-		BCMLOG_ERR("Invalid adp\n");
+		dev_err(dev, "Invalid adp\n");
 		return -EINVAL;
 	}
 
 	uc = fd->private_data;
 	if (!uc) {
-		BCMLOG_ERR("Failed to get uc\n");
+		dev_err(dev, "Failed to get uc\n");
 		return -ENODATA;
 	}
 
-	crystalhd_user_close(&adp->cmds, uc);
+	/* Check and close only if we have not flush/closed before */
+	/* This is needed because release is not guarenteed to be called immediately on close,
+	 * if duplicate file handles exist due to fork etc. This causes problems with close and re-open
+	 of the device immediately */
+
+	if(uc->in_use) {
+		mode = uc->mode;
+
+		ctx->user[uc->uid].mode = DTS_MODE_INV;
+		ctx->user[uc->uid].in_use = 0;
+
+		dev_info(chddev(), "Closing user[%x] handle with mode %x\n", uc->uid, mode);
+
+		if (((mode & 0xFF) == DTS_DIAG_MODE) ||
+			((mode & 0xFF) == DTS_PLAYBACK_MODE) ||
+			((bc_get_userhandle_count(ctx) == 0) && (ctx->hw_ctx != NULL))) {
+			ctx->cin_wait_exit = 1;
+			ctx->pwr_state_change = BC_HW_RUNNING;
+			/* Stop the HW Capture just in case flush did not get called before stop */
+			/* And only if we had actually started it */
+			if(ctx->hw_ctx->rx_freeq != NULL) {
+				crystalhd_hw_stop_capture(ctx->hw_ctx, true);
+				crystalhd_hw_free_dma_rings(ctx->hw_ctx);
+			}
+			if(ctx->adp->fill_byte_pool)
+				crystalhd_destroy_dio_pool(ctx->adp);
+			if(ctx->adp->elem_pool_head)
+				crystalhd_delete_elem_pool(ctx->adp);
+			ctx->state = BC_LINK_INVALID;
+			crystalhd_hw_close(ctx->hw_ctx, ctx->adp);
+			kfree(ctx->hw_ctx);
+			ctx->hw_ctx = NULL;
+		}
+
+		uc->in_use = 0;
 
-	adp->cfg_users--;
+		if(adp->cfg_users > 0)
+			adp->cfg_users--;
+	}
 
 	return 0;
 }
 
 static const struct file_operations chd_dec_fops = {
-	.owner   = THIS_MODULE,
-	.unlocked_ioctl = chd_dec_ioctl,
-	.open    = chd_dec_open,
-	.release = chd_dec_close,
-	.llseek = noop_llseek,
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl	= chd_dec_ioctl,
+	.open		= chd_dec_open,
+	.release	= chd_dec_close,
+	.llseek		= noop_llseek,
 };
 
 static int chd_dec_init_chdev(struct crystalhd_adp *adp)
 {
-	struct crystalhd_ioctl_data *temp;
+	struct device *xdev = &adp->pdev->dev;
 	struct device *dev;
+	struct crystalhd_ioctl_data *temp;
 	int rc = -ENODEV, i = 0;
 
 	if (!adp)
@@ -365,7 +432,7 @@ static int chd_dec_init_chdev(struct crystalhd_adp *adp)
 	adp->chd_dec_major = register_chrdev(0, CRYSTALHD_API_NAME,
 					     &chd_dec_fops);
 	if (adp->chd_dec_major < 0) {
-		BCMLOG_ERR("Failed to create config dev\n");
+		dev_err(xdev, "Failed to create config dev\n");
 		rc = adp->chd_dec_major;
 		goto fail;
 	}
@@ -374,7 +441,7 @@ static int chd_dec_init_chdev(struct crystalhd_adp *adp)
 	crystalhd_class = class_create(THIS_MODULE, "crystalhd");
 	if (IS_ERR(crystalhd_class)) {
 		rc = PTR_ERR(crystalhd_class);
-		BCMLOG_ERR("failed to create class\n");
+		dev_err(xdev, "failed to create class\n");
 		goto class_create_fail;
 	}
 
@@ -382,22 +449,22 @@ static int chd_dec_init_chdev(struct crystalhd_adp *adp)
 			 MKDEV(adp->chd_dec_major, 0), NULL, "crystalhd");
 	if (IS_ERR(dev)) {
 		rc = PTR_ERR(dev);
-		BCMLOG_ERR("failed to create device\n");
+		dev_err(xdev, "failed to create device\n");
 		goto device_create_fail;
 	}
 
-	rc = crystalhd_create_elem_pool(adp, BC_LINK_ELEM_POOL_SZ);
-	if (rc) {
-		BCMLOG_ERR("failed to create device\n");
-		goto elem_pool_fail;
-	}
+/*	rc = crystalhd_create_elem_pool(adp, BC_LINK_ELEM_POOL_SZ); */
+/*	if (rc) { */
+/*		dev_err(xdev, "failed to create device\n"); */
+/*		goto elem_pool_fail; */
+/*	} */
 
 	/* Allocate general purpose ioctl pool. */
 	for (i = 0; i < CHD_IODATA_POOL_SZ; i++) {
 		temp = kzalloc(sizeof(struct crystalhd_ioctl_data),
 					 GFP_KERNEL);
 		if (!temp) {
-			BCMLOG_ERR("ioctl data pool kzalloc failed\n");
+			dev_err(xdev, "ioctl data pool kzalloc failed\n");
 			rc = -ENOMEM;
 			goto kzalloc_fail;
 		}
@@ -408,8 +475,8 @@ static int chd_dec_init_chdev(struct crystalhd_adp *adp)
 	return 0;
 
 kzalloc_fail:
-	crystalhd_delete_elem_pool(adp);
-elem_pool_fail:
+	/*crystalhd_delete_elem_pool(adp); */
+/*elem_pool_fail: */
 	device_destroy(crystalhd_class, MKDEV(adp->chd_dec_major, 0));
 device_create_fail:
 	class_destroy(crystalhd_class);
@@ -429,7 +496,7 @@ static void chd_dec_release_chdev(struct crystalhd_adp *adp)
 		/* unregister crystalhd class */
 		device_destroy(crystalhd_class, MKDEV(adp->chd_dec_major, 0));
 		unregister_chrdev(adp->chd_dec_major, CRYSTALHD_API_NAME);
-		BCMLOG(BCMLOG_INFO, "released api device - %d\n",
+		dev_info(chddev(), "released api device - %d\n",
 		       adp->chd_dec_major);
 		class_destroy(crystalhd_class);
 	}
@@ -441,58 +508,64 @@ static void chd_dec_release_chdev(struct crystalhd_adp *adp)
 		kfree(temp);
 	} while (temp);
 
-	crystalhd_delete_elem_pool(adp);
+	/*crystalhd_delete_elem_pool(adp); */
 }
 
 static int chd_pci_reserve_mem(struct crystalhd_adp *pinfo)
 {
+	struct device *dev = &pinfo->pdev->dev;
 	int rc;
-	unsigned long bar2 = pci_resource_start(pinfo->pdev, 2);
-	uint32_t mem_len   = pci_resource_len(pinfo->pdev, 2);
-	unsigned long bar0 = pci_resource_start(pinfo->pdev, 0);
-	uint32_t i2o_len   = pci_resource_len(pinfo->pdev, 0);
 
-	BCMLOG(BCMLOG_SSTEP, "bar2:0x%lx-0x%08x  bar0:0x%lx-0x%08x\n",
-	       bar2, mem_len, bar0, i2o_len);
+	uint32_t bar0		= pci_resource_start(pinfo->pdev, 0);
+	uint32_t i2o_len	= pci_resource_len(pinfo->pdev, 0);
 
-	rc = check_mem_region(bar2, mem_len);
+	uint32_t bar2		= pci_resource_start(pinfo->pdev, 2);
+	uint32_t mem_len	= pci_resource_len(pinfo->pdev, 2);
+
+	dev_dbg(dev, "bar0:0x%x-0x%08x  bar2:0x%x-0x%08x\n",
+	        bar0, i2o_len, bar2, mem_len);
+
+	/* bar-0 */
+	rc = check_mem_region(bar0, i2o_len);
 	if (rc) {
-		BCMLOG_ERR("No valid mem region...\n");
+		printk(KERN_ERR "No valid mem region...\n");
 		return -ENOMEM;
 	}
 
-	pinfo->addr = ioremap_nocache(bar2, mem_len);
-	if (!pinfo->addr) {
-		BCMLOG_ERR("Failed to remap mem region...\n");
+	pinfo->i2o_addr = ioremap_nocache(bar0, i2o_len);
+	if (!pinfo->i2o_addr) {
+		printk(KERN_ERR "Failed to remap i2o region...\n");
 		return -ENOMEM;
 	}
 
-	pinfo->pci_mem_start = bar2;
-	pinfo->pci_mem_len   = mem_len;
+	pinfo->pci_i2o_start = bar0;
+	pinfo->pci_i2o_len   = i2o_len;
 
-	rc = check_mem_region(bar0, i2o_len);
+	/* bar-2 */
+	rc = check_mem_region(bar2, mem_len);
 	if (rc) {
-		BCMLOG_ERR("No valid mem region...\n");
+		printk(KERN_ERR "No valid mem region...\n");
 		return -ENOMEM;
 	}
 
-	pinfo->i2o_addr = ioremap_nocache(bar0, i2o_len);
-	if (!pinfo->i2o_addr) {
-		BCMLOG_ERR("Failed to remap mem region...\n");
+	pinfo->mem_addr = ioremap_nocache(bar2, mem_len);
+	if (!pinfo->mem_addr) {
+		printk(KERN_ERR "Failed to remap mem region...\n");
 		return -ENOMEM;
 	}
 
-	pinfo->pci_i2o_start = bar0;
-	pinfo->pci_i2o_len   = i2o_len;
+	pinfo->pci_mem_start = bar2;
+	pinfo->pci_mem_len   = mem_len;
 
+	/* pdev */
 	rc = pci_request_regions(pinfo->pdev, pinfo->name);
 	if (rc < 0) {
-		BCMLOG_ERR("Region request failed: %d\n", rc);
+		printk(KERN_ERR "Region request failed: %d\n", rc);
 		return rc;
 	}
 
-	BCMLOG(BCMLOG_SSTEP, "Mapped addr:0x%08lx  i2o_addr:0x%08lx\n",
-	       (unsigned long)pinfo->addr, (unsigned long)pinfo->i2o_addr);
+	dev_dbg(dev, "i2o_addr:0x%08lx   Mapped addr:0x%08lx  \n",
+	        (unsigned long)pinfo->i2o_addr, (unsigned long)pinfo->mem_addr);
 
 	return 0;
 }
@@ -502,8 +575,8 @@ static void chd_pci_release_mem(struct crystalhd_adp *pinfo)
 	if (!pinfo)
 		return;
 
-	if (pinfo->addr)
-		iounmap(pinfo->addr);
+	if (pinfo->mem_addr)
+		iounmap(pinfo->mem_addr);
 
 	if (pinfo->i2o_addr)
 		iounmap(pinfo->i2o_addr);
@@ -517,15 +590,17 @@ static void chd_dec_pci_remove(struct pci_dev *pdev)
 	struct crystalhd_adp *pinfo;
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 
+	dev_dbg(chddev(), "Entering %s\n", __func__);
+
 	pinfo = pci_get_drvdata(pdev);
 	if (!pinfo) {
-		BCMLOG_ERR("could not get adp\n");
+		dev_err(chddev(), "could not get adp\n");
 		return;
 	}
 
 	sts = crystalhd_delete_cmd_context(&pinfo->cmds);
 	if (sts != BC_STS_SUCCESS)
-		BCMLOG_ERR("cmd delete :%d\n", sts);
+		dev_err(chddev(), "cmd delete :%d\n", sts);
 
 	chd_dec_release_chdev(pinfo);
 
@@ -541,26 +616,26 @@ static void chd_dec_pci_remove(struct pci_dev *pdev)
 static int chd_dec_pci_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *entry)
 {
+	struct device *dev = &pdev->dev;
 	struct crystalhd_adp *pinfo;
 	int rc;
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 
-	BCMLOG(BCMLOG_DBG, "PCI_INFO: Vendor:0x%04x Device:0x%04x s_vendor:0x%04x s_device: 0x%04x\n",
-	       pdev->vendor, pdev->device, pdev->subsystem_vendor,
-	       pdev->subsystem_device);
+	dev_info(dev, "Starting Device:0x%04x\n", pdev->device);
 
 	pinfo = kzalloc(sizeof(struct crystalhd_adp), GFP_KERNEL);
 	if (!pinfo) {
-		BCMLOG_ERR("Failed to allocate memory\n");
-		return -ENOMEM;
+		dev_err(dev, "%s: Failed to allocate memory\n", __func__);
+		rc = -ENOMEM;
+		goto out;
 	}
 
 	pinfo->pdev = pdev;
 
 	rc = pci_enable_device(pdev);
 	if (rc) {
-		BCMLOG_ERR("Failed to enable PCI device\n");
-		goto err;
+		dev_err(dev, "%s: Failed to enable PCI device\n", __func__);
+		goto free_priv;
 	}
 
 	snprintf(pinfo->name, sizeof(pinfo->name), "crystalhd_pci_e:%d:%d:%d",
@@ -569,10 +644,9 @@ static int chd_dec_pci_probe(struct pci_dev *pdev,
 
 	rc = chd_pci_reserve_mem(pinfo);
 	if (rc) {
-		BCMLOG_ERR("Failed to setup memory regions.\n");
-		pci_disable_device(pdev);
-		rc = -ENOMEM;
-		goto err;
+		dev_err(dev, "%s: Failed to set up memory regions.\n",
+			__func__);
+		goto disable_device;
 	}
 
 	pinfo->present	= 1;
@@ -582,13 +656,14 @@ static int chd_dec_pci_probe(struct pci_dev *pdev,
 	spin_lock_init(&pinfo->lock);
 
 	/* setup api stuff.. */
-	chd_dec_init_chdev(pinfo);
+	rc = chd_dec_init_chdev(pinfo);
+	if (rc)
+		goto release_mem;
+
 	rc = chd_dec_enable_int(pinfo);
 	if (rc) {
-		BCMLOG_ERR("_enable_int err:%d\n", rc);
-		pci_disable_device(pdev);
-		rc = -ENODEV;
-		goto err;
+		dev_err(dev, "%s: _enable_int err:%d\n", __func__, rc);
+		goto cleanup_chdev;
 	}
 
 	/* Set dma mask... */
@@ -599,18 +674,16 @@ static int chd_dec_pci_probe(struct pci_dev *pdev,
 		pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 		pinfo->dmabits = 32;
 	} else {
-		BCMLOG_ERR("Unabled to setup DMA %d\n", rc);
-		pci_disable_device(pdev);
+		dev_err(dev, "%s: Unabled to setup DMA %d\n", __func__, rc);
 		rc = -ENODEV;
-		goto err;
+		goto cleanup_int;
 	}
 
 	sts = crystalhd_setup_cmd_context(&pinfo->cmds, pinfo);
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("cmd setup :%d\n", sts);
-		pci_disable_device(pdev);
+		dev_err(dev, "%s: cmd setup :%d\n", __func__, sts);
 		rc = -ENODEV;
-		goto err;
+		goto cleanup_int;
 	}
 
 	pci_set_master(pdev);
@@ -619,35 +692,44 @@ static int chd_dec_pci_probe(struct pci_dev *pdev,
 
 	g_adp_info = pinfo;
 
-	return 0;
-
-err:
-	kfree(pinfo);
+out:
 	return rc;
+cleanup_int:
+	chd_dec_disable_int(pinfo);
+cleanup_chdev:
+	chd_dec_release_chdev(pinfo);
+release_mem:
+	chd_pci_release_mem(pinfo);
+disable_device:
+	pci_disable_device(pdev);
+free_priv:
+	kfree(pdev);
+	goto out;
 }
 
-#ifdef CONFIG_PM
 int chd_dec_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct crystalhd_adp *adp;
+	struct device *dev = &pdev->dev;
 	struct crystalhd_ioctl_data *temp;
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 
-	adp = pci_get_drvdata(pdev);
+	adp = (struct crystalhd_adp *)pci_get_drvdata(pdev);
 	if (!adp) {
-		BCMLOG_ERR("could not get adp\n");
+		dev_err(dev, "%s: could not get adp\n", __func__);
 		return -ENODEV;
 	}
 
 	temp = chd_dec_alloc_iodata(adp, false);
 	if (!temp) {
-		BCMLOG_ERR("could not get ioctl data\n");
+		dev_err(dev, "could not get ioctl data\n");
 		return -ENODEV;
 	}
 
 	sts = crystalhd_suspend(&adp->cmds, temp);
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("BCM70012 Suspend %d\n", sts);
+		dev_err(dev, "Crystal HD Suspend %d\n", sts);
+		chd_dec_free_iodata(adp, temp, false);
 		return -ENODEV;
 	}
 
@@ -664,12 +746,13 @@ int chd_dec_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 int chd_dec_pci_resume(struct pci_dev *pdev)
 {
 	struct crystalhd_adp *adp;
+	struct device *dev = &pdev->dev;
 	enum BC_STATUS sts = BC_STS_SUCCESS;
 	int rc;
 
-	adp = pci_get_drvdata(pdev);
+	adp = (struct crystalhd_adp *)pci_get_drvdata(pdev);
 	if (!adp) {
-		BCMLOG_ERR("could not get adp\n");
+		dev_err(dev, "%s: could not get adp\n", __func__);
 		return -ENODEV;
 	}
 
@@ -678,7 +761,7 @@ int chd_dec_pci_resume(struct pci_dev *pdev)
 
 	/* device's irq possibly is changed, driver should take care */
 	if (pci_enable_device(pdev)) {
-		BCMLOG_ERR("Failed to enable PCI device\n");
+		dev_err(dev, "Failed to enable PCI device\n");
 		return 1;
 	}
 
@@ -686,59 +769,37 @@ int chd_dec_pci_resume(struct pci_dev *pdev)
 
 	rc = chd_dec_enable_int(adp);
 	if (rc) {
-		BCMLOG_ERR("_enable_int err:%d\n", rc);
+		dev_err(dev, "_enable_int err:%d\n", rc);
 		pci_disable_device(pdev);
 		return -ENODEV;
 	}
 
 	sts = crystalhd_resume(&adp->cmds);
 	if (sts != BC_STS_SUCCESS) {
-		BCMLOG_ERR("BCM70012 Resume %d\n", sts);
+		dev_err(dev, "Crystal HD Resume %d\n", sts);
 		pci_disable_device(pdev);
 		return -ENODEV;
 	}
 
 	return 0;
 }
-#endif
 
 static DEFINE_PCI_DEVICE_TABLE(chd_dec_pci_id_table) = {
 	{ PCI_VDEVICE(BROADCOM, 0x1612), 8 },
+	{ PCI_VDEVICE(BROADCOM, 0x1615), 8 },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, chd_dec_pci_id_table);
 
-static struct pci_driver bc_chd_70012_driver = {
-	.name     = "Broadcom 70012 Decoder",
+static struct pci_driver bc_chd_driver = {
+	.name     = "crystalhd",
 	.probe    = chd_dec_pci_probe,
 	.remove   = chd_dec_pci_remove,
 	.id_table = chd_dec_pci_id_table,
-#ifdef CONFIG_PM
 	.suspend  = chd_dec_pci_suspend,
 	.resume   = chd_dec_pci_resume
-#endif
 };
 
-void chd_set_log_level(struct crystalhd_adp *adp, char *arg)
-{
-	if ((!arg) || (strlen(arg) < 3))
-		g_linklog_level = BCMLOG_ERROR | BCMLOG_DATA;
-	else if (!strncmp(arg, "sstep", 5))
-		g_linklog_level = BCMLOG_INFO | BCMLOG_DATA | BCMLOG_DBG |
-				  BCMLOG_SSTEP | BCMLOG_ERROR;
-	else if (!strncmp(arg, "info", 4))
-		g_linklog_level = BCMLOG_ERROR | BCMLOG_DATA | BCMLOG_INFO;
-	else if (!strncmp(arg, "debug", 5))
-		g_linklog_level = BCMLOG_ERROR | BCMLOG_DATA | BCMLOG_INFO |
-				  BCMLOG_DBG;
-	else if (!strncmp(arg, "pball", 5))
-		g_linklog_level = 0xFFFFFFFF & ~(BCMLOG_SPINLOCK);
-	else if (!strncmp(arg, "silent", 6))
-		g_linklog_level = 0;
-	else
-		g_linklog_level = 0;
-}
-
 struct crystalhd_adp *chd_get_adp(void)
 {
 	return g_adp_info;
@@ -748,14 +809,14 @@ static int __init chd_dec_module_init(void)
 {
 	int rc;
 
-	chd_set_log_level(NULL, "debug");
-	BCMLOG(BCMLOG_DATA, "Loading crystalhd %d.%d.%d\n",
+	printk(KERN_DEBUG "Loading crystalhd v%d.%d.%d\n",
 	       crystalhd_kmod_major, crystalhd_kmod_minor, crystalhd_kmod_rev);
 
-	rc = pci_register_driver(&bc_chd_70012_driver);
+	rc = pci_register_driver(&bc_chd_driver);
 
 	if (rc < 0)
-		BCMLOG_ERR("Could not find any devices. err:%d\n", rc);
+		printk(KERN_ERR "%s: Could not find any devices. err:%d\n",
+		       __func__, rc);
 
 	return rc;
 }
@@ -763,10 +824,10 @@ module_init(chd_dec_module_init);
 
 static void __exit chd_dec_module_cleanup(void)
 {
-	BCMLOG(BCMLOG_DATA, "unloading crystalhd %d.%d.%d\n",
+	printk(KERN_DEBUG "Unloading crystalhd %d.%d.%d\n",
 	       crystalhd_kmod_major, crystalhd_kmod_minor, crystalhd_kmod_rev);
 
-	pci_unregister_driver(&bc_chd_70012_driver);
+	pci_unregister_driver(&bc_chd_driver);
 }
 module_exit(chd_dec_module_cleanup);
 
@@ -774,4 +835,4 @@ MODULE_AUTHOR("Naren Sankar <nsankar@broadcom.com>");
 MODULE_AUTHOR("Prasad Bolisetty <prasadb@broadcom.com>");
 MODULE_DESCRIPTION(CRYSTAL_HD_NAME);
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("bcm70012");
+MODULE_ALIAS("crystalhd");
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.h b/drivers/staging/crystalhd/crystalhd_lnx.h
index bac572a..f8d872c 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.h
+++ b/drivers/staging/crystalhd/crystalhd_lnx.h
@@ -49,21 +49,21 @@
 
 #include "crystalhd.h"
 
-#define CRYSTAL_HD_NAME		"Broadcom Crystal HD Decoder (BCM70012) Driver"
+#define CRYSTAL_HD_NAME "Broadcom Crystal HD Decoder Driver"
 
 /* OS specific PCI information structure and adapter information. */
 struct crystalhd_adp {
-	/* Hardware borad/PCI specifics */
+	/* Hardware board/PCI specifics */
 	char			name[32];
 	struct pci_dev		*pdev;
 
 	unsigned long		pci_mem_start;
-	uint32_t		pci_mem_len;
-	void			*addr;
+	uint32_t			pci_mem_len;
+	void				*mem_addr;
 
 	unsigned long		pci_i2o_start;
-	uint32_t		pci_i2o_len;
-	void			*i2o_addr;
+	uint32_t			pci_i2o_len;
+	void				*i2o_addr;
 
 	unsigned int		drv_data;
 	unsigned int		dmabits;	/* 32 | 64 */
@@ -74,7 +74,7 @@ struct crystalhd_adp {
 	spinlock_t		lock;
 
 	/* API Related */
-	int		chd_dec_major;
+	int			chd_dec_major;
 	unsigned int		cfg_users;
 
 	struct crystalhd_ioctl_data	*idata_free_head; /* ioctl data pool */
@@ -88,7 +88,6 @@ struct crystalhd_adp {
 

 struct crystalhd_adp *chd_get_adp(void);
-void chd_set_log_level(struct crystalhd_adp *adp, char *arg);
+struct device *chddev(void);
 
 #endif
-
diff --git a/drivers/staging/crystalhd/crystalhd_misc.c b/drivers/staging/crystalhd/crystalhd_misc.c
index 51f6980..fc143eb 100644
--- a/drivers/staging/crystalhd/crystalhd_misc.c
+++ b/drivers/staging/crystalhd/crystalhd_misc.c
@@ -24,31 +24,16 @@
  * along with this driver.  If not, see <http://www.gnu.org/licenses/>.
  **********************************************************************/
 
+#include <linux/device.h>
+#include <linux/version.h>
 #include "crystalhd.h"
 
 #include <linux/slab.h>
 
-uint32_t g_linklog_level;
 
-static inline uint32_t crystalhd_dram_rd(struct crystalhd_adp *adp,
-					 uint32_t mem_off)
-{
-	crystalhd_reg_wr(adp, DCI_DRAM_BASE_ADDR, (mem_off >> 19));
-	return bc_dec_reg_rd(adp, (0x00380000 | (mem_off & 0x0007FFFF)));
-}
-
-static inline void crystalhd_dram_wr(struct crystalhd_adp *adp,
-					 uint32_t mem_off, uint32_t val)
-{
-	crystalhd_reg_wr(adp, DCI_DRAM_BASE_ADDR, (mem_off >> 19));
-	bc_dec_reg_wr(adp, (0x00380000 | (mem_off & 0x0007FFFF)), val);
-}
-
-static inline enum BC_STATUS bc_chk_dram_range(struct crystalhd_adp *adp,
-					 uint32_t start_off, uint32_t cnt)
-{
-	return BC_STS_SUCCESS;
-}
+/* Some HW specific code defines */
+extern uint32_t link_GetRptDropParam(struct crystalhd_hw *hw, uint32_t picHeight, uint32_t picWidth, void *);
+extern uint32_t flea_GetRptDropParam(struct crystalhd_hw *hw, void *);
 
 static struct crystalhd_dio_req *crystalhd_alloc_dio(struct crystalhd_adp *adp)
 {
@@ -56,7 +41,7 @@ static struct crystalhd_dio_req *crystalhd_alloc_dio(struct crystalhd_adp *adp)
 	struct crystalhd_dio_req *temp = NULL;
 
 	if (!adp) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		printk(KERN_ERR "%s: Invalid arg\n", __func__);
 		return temp;
 	}
 
@@ -92,13 +77,17 @@ static struct crystalhd_elem *crystalhd_alloc_elem(struct crystalhd_adp *adp)
 	struct crystalhd_elem *temp = NULL;
 
 	if (!adp)
+	{
+		printk(KERN_ERR "%s: Invalid args\n", __func__);
 		return temp;
+	}
 	spin_lock_irqsave(&adp->lock, flags);
 	temp = adp->elem_pool_head;
 	if (temp) {
 		adp->elem_pool_head = adp->elem_pool_head->flink;
 		memset(temp, 0, sizeof(*temp));
 	}
+
 	spin_unlock_irqrestore(&adp->lock, flags);
 
 	return temp;
@@ -134,153 +123,6 @@ static inline void crystalhd_init_sg(struct scatterlist *sg,
 
 /*========================== Extern ========================================*/
 /**
- * bc_dec_reg_rd - Read 7412's device register.
- * @adp: Adapter instance
- * @reg_off: Register offset.
- *
- * Return:
- *	32bit value read
- *
- * 7412's device register read routine. This interface use
- * 7412's device access range mapped from BAR-2 (4M) of PCIe
- * configuration space.
- */
-uint32_t bc_dec_reg_rd(struct crystalhd_adp *adp, uint32_t reg_off)
-{
-	if (!adp || (reg_off > adp->pci_mem_len)) {
-		BCMLOG_ERR("dec_rd_reg_off outof range: 0x%08x\n", reg_off);
-		return 0;
-	}
-
-	return readl(adp->addr + reg_off);
-}
-
-/**
- * bc_dec_reg_wr - Write 7412's device register
- * @adp: Adapter instance
- * @reg_off: Register offset.
- * @val: Dword value to be written.
- *
- * Return:
- *	none.
- *
- * 7412's device register write routine. This interface use
- * 7412's device access range mapped from BAR-2 (4M) of PCIe
- * configuration space.
- */
-void bc_dec_reg_wr(struct crystalhd_adp *adp, uint32_t reg_off, uint32_t val)
-{
-	if (!adp || (reg_off > adp->pci_mem_len)) {
-		BCMLOG_ERR("dec_wr_reg_off outof range: 0x%08x\n", reg_off);
-		return;
-	}
-	writel(val, adp->addr + reg_off);
-	udelay(8);
-}
-
-/**
- * crystalhd_reg_rd - Read Link's device register.
- * @adp: Adapter instance
- * @reg_off: Register offset.
- *
- * Return:
- *	32bit value read
- *
- * Link device register  read routine. This interface use
- * Link's device access range mapped from BAR-1 (64K) of PCIe
- * configuration space.
- *
- */
-uint32_t crystalhd_reg_rd(struct crystalhd_adp *adp, uint32_t reg_off)
-{
-	if (!adp || (reg_off > adp->pci_i2o_len)) {
-		BCMLOG_ERR("link_rd_reg_off outof range: 0x%08x\n", reg_off);
-		return 0;
-	}
-	return readl(adp->i2o_addr + reg_off);
-}
-
-/**
- * crystalhd_reg_wr - Write Link's device register
- * @adp: Adapter instance
- * @reg_off: Register offset.
- * @val: Dword value to be written.
- *
- * Return:
- *	none.
- *
- * Link device register  write routine. This interface use
- * Link's device access range mapped from BAR-1 (64K) of PCIe
- * configuration space.
- *
- */
-void crystalhd_reg_wr(struct crystalhd_adp *adp, uint32_t reg_off,
-					 uint32_t val)
-{
-	if (!adp || (reg_off > adp->pci_i2o_len)) {
-		BCMLOG_ERR("link_wr_reg_off outof range: 0x%08x\n", reg_off);
-		return;
-	}
-	writel(val, adp->i2o_addr + reg_off);
-}
-
-/**
- * crystalhd_mem_rd - Read data from 7412's DRAM area.
- * @adp: Adapter instance
- * @start_off: Start offset.
- * @dw_cnt: Count in dwords.
- * @rd_buff: Buffer to copy the data from dram.
- *
- * Return:
- *	Status.
- *
- * 7412's Dram read routine.
- */
-enum BC_STATUS crystalhd_mem_rd(struct crystalhd_adp *adp, uint32_t start_off,
-			 uint32_t dw_cnt, uint32_t *rd_buff)
-{
-	uint32_t ix = 0;
-
-	if (!adp || !rd_buff ||
-	    (bc_chk_dram_range(adp, start_off, dw_cnt) != BC_STS_SUCCESS)) {
-		BCMLOG_ERR("Invalid arg\n");
-		return BC_STS_INV_ARG;
-	}
-	for (ix = 0; ix < dw_cnt; ix++)
-		rd_buff[ix] = crystalhd_dram_rd(adp, (start_off + (ix * 4)));
-
-	return BC_STS_SUCCESS;
-}
-
-/**
- * crystalhd_mem_wr - Write data to 7412's DRAM area.
- * @adp: Adapter instance
- * @start_off: Start offset.
- * @dw_cnt: Count in dwords.
- * @wr_buff: Data Buffer to be written.
- *
- * Return:
- *	Status.
- *
- * 7412's Dram write routine.
- */
-enum BC_STATUS crystalhd_mem_wr(struct crystalhd_adp *adp, uint32_t start_off,
-			 uint32_t dw_cnt, uint32_t *wr_buff)
-{
-	uint32_t ix = 0;
-
-	if (!adp || !wr_buff ||
-	    (bc_chk_dram_range(adp, start_off, dw_cnt) != BC_STS_SUCCESS)) {
-		BCMLOG_ERR("Invalid arg\n");
-		return BC_STS_INV_ARG;
-	}
-
-	for (ix = 0; ix < dw_cnt; ix++)
-		crystalhd_dram_wr(adp, (start_off + (ix * 4)), wr_buff[ix]);
-
-	return BC_STS_SUCCESS;
-}
-/**
  * crystalhd_pci_cfg_rd - PCIe config read
  * @adp: Adapter instance
  * @off: PCI config space offset.
@@ -290,7 +132,7 @@ enum BC_STATUS crystalhd_mem_wr(struct crystalhd_adp *adp, uint32_t start_off,
  * Return:
  *	Status.
  *
- * Get value from Link's PCIe config space.
+ * Get value from PCIe config space.
  */
 enum BC_STATUS crystalhd_pci_cfg_rd(struct crystalhd_adp *adp, uint32_t off,
 			     uint32_t len, uint32_t *val)
@@ -299,7 +141,7 @@ enum BC_STATUS crystalhd_pci_cfg_rd(struct crystalhd_adp *adp, uint32_t off,
 	int rc = 0;
 
 	if (!adp || !val) {
-		BCMLOG_ERR("Invalid arg\n");
+		printk(KERN_ERR "%s: Invalid arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -316,8 +158,8 @@ enum BC_STATUS crystalhd_pci_cfg_rd(struct crystalhd_adp *adp, uint32_t off,
 	default:
 		rc = -EINVAL;
 		sts = BC_STS_INV_ARG;
-		BCMLOG_ERR("Invalid len:%d\n", len);
-	}
+		dev_err(&adp->pdev->dev, "Invalid len:%d\n", len);
+	};
 
 	if (rc && (sts == BC_STS_SUCCESS))
 		sts = BC_STS_ERROR;
@@ -344,7 +186,7 @@ enum BC_STATUS crystalhd_pci_cfg_wr(struct crystalhd_adp *adp, uint32_t off,
 	int rc = 0;
 
 	if (!adp || !val) {
-		BCMLOG_ERR("Invalid arg\n");
+		printk(KERN_ERR "%s: Invalid arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -361,8 +203,8 @@ enum BC_STATUS crystalhd_pci_cfg_wr(struct crystalhd_adp *adp, uint32_t off,
 	default:
 		rc = -EINVAL;
 		sts = BC_STS_INV_ARG;
-		BCMLOG_ERR("Invalid len:%d\n", len);
-	}
+		dev_err(&adp->pdev->dev, "Invalid len:%d\n", len);
+	};
 
 	if (rc && (sts == BC_STS_SUCCESS))
 		sts = BC_STS_ERROR;
@@ -389,7 +231,7 @@ void *bc_kern_dma_alloc(struct crystalhd_adp *adp, uint32_t sz,
 	void *temp = NULL;
 
 	if (!adp || !sz || !phy_addr) {
-		BCMLOG_ERR("Invalide Arg..\n");
+		printk(KERN_ERR "%s: Invalid arg\n", __func__);
 		return temp;
 	}
 
@@ -415,7 +257,7 @@ void bc_kern_dma_free(struct crystalhd_adp *adp, uint32_t sz, void *ka,
 		      dma_addr_t phy_addr)
 {
 	if (!adp || !ka || !sz || !phy_addr) {
-		BCMLOG_ERR("Invalide Arg..\n");
+		printk(KERN_ERR "%s: Invalid arg\n", __func__);
 		return;
 	}
 
@@ -442,7 +284,7 @@ enum BC_STATUS crystalhd_create_dioq(struct crystalhd_adp *adp,
 	struct crystalhd_dioq *dioq = NULL;
 
 	if (!adp || !dioq_hnd) {
-		BCMLOG_ERR("Invalid arg!!\n");
+		printk(KERN_ERR "%s: Invalid arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -477,7 +319,7 @@ enum BC_STATUS crystalhd_create_dioq(struct crystalhd_adp *adp,
  *
  */
 void crystalhd_delete_dioq(struct crystalhd_adp *adp,
-			 struct crystalhd_dioq *dioq)
+					struct crystalhd_dioq *dioq)
 {
 	void *temp;
 
@@ -512,13 +354,13 @@ enum BC_STATUS crystalhd_dioq_add(struct crystalhd_dioq *ioq, void *data,
 	struct crystalhd_elem *tmp;
 
 	if (!ioq || (ioq->sig != BC_LINK_DIOQ_SIG) || !data) {
-		BCMLOG_ERR("Invalid arg!!\n");
+		dev_err(chddev(), "%s: Invalid arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
 	tmp = crystalhd_alloc_elem(ioq->adp);
 	if (!tmp) {
-		BCMLOG_ERR("No free elements.\n");
+		dev_err(chddev(), "%s: No free elements.\n", __func__);
 		return BC_STS_INSUFF_RES;
 	}
 
@@ -555,7 +397,11 @@ void *crystalhd_dioq_fetch(struct crystalhd_dioq *ioq)
 	void *data = NULL;
 
 	if (!ioq || (ioq->sig != BC_LINK_DIOQ_SIG)) {
-		BCMLOG_ERR("Invalid arg!!\n");
+		dev_err(chddev(), "%s: Invalid arg\n", __func__);
+		if(!ioq)
+			dev_err(chddev(), "ioq not initialized\n");
+		else
+			dev_err(chddev(), "ioq invalid signature\n");
 		return data;
 	}
 
@@ -593,7 +439,7 @@ void *crystalhd_dioq_find_and_fetch(struct crystalhd_dioq *ioq, uint32_t tag)
 	void *data = NULL;
 
 	if (!ioq || (ioq->sig != BC_LINK_DIOQ_SIG)) {
-		BCMLOG_ERR("Invalid arg!!\n");
+		dev_err(chddev(), "%s: Invalid arg\n", __func__);
 		return data;
 	}
 
@@ -630,39 +476,88 @@ void *crystalhd_dioq_find_and_fetch(struct crystalhd_dioq *ioq, uint32_t tag)
  * Return element from head if Q is not empty. Wait for new element
  * if Q is empty for Timeout seconds.
  */
-void *crystalhd_dioq_fetch_wait(struct crystalhd_dioq *ioq, uint32_t to_secs,
-			      uint32_t *sig_pend)
+void *crystalhd_dioq_fetch_wait(struct crystalhd_hw *hw, uint32_t to_secs, uint32_t *sig_pend)
 {
+	struct device *dev = chddev();
 	unsigned long flags = 0;
-	int rc = 0, count;
-	void *tmp = NULL;
+	int rc = 0;
+
+	struct crystalhd_rx_dma_pkt *r_pkt = NULL;
+	struct crystalhd_dioq *ioq = hw->rx_rdyq;
+	uint32_t picYcomp = 0;
+
+	unsigned long fetchTimeout = jiffies + msecs_to_jiffies(to_secs * 1000);
 
 	if (!ioq || (ioq->sig != BC_LINK_DIOQ_SIG) || !to_secs || !sig_pend) {
-		BCMLOG_ERR("Invalid arg!!\n");
-		return tmp;
+		dev_err(dev, "%s: Invalid arg\n", __func__);
+		return r_pkt;
 	}
 
-	count = to_secs;
 	spin_lock_irqsave(&ioq->lock, flags);
-	while ((ioq->count == 0) && count) {
-		spin_unlock_irqrestore(&ioq->lock, flags);
-
-		crystalhd_wait_on_event(&ioq->event,
-				 (ioq->count > 0), 1000, rc, 0);
+	while (!time_after_eq(jiffies, fetchTimeout)) {
+		if(ioq->count == 0) {
+			spin_unlock_irqrestore(&ioq->lock, flags);
+			crystalhd_wait_on_event(&ioq->event, (ioq->count > 0),
+					250, rc, false);
+		}
+		else
+			spin_unlock_irqrestore(&ioq->lock, flags);
 		if (rc == 0) {
-			goto out;
+			/* Found a packet. Check if it is a repeated picture or not */
+			/* Drop the picture if it is a repeated picture */
+			/* Lock against checks from get status calls */
+			if(down_interruptible(&hw->fetch_sem))
+				goto sem_error;
+			r_pkt = crystalhd_dioq_fetch(ioq);
+			/* If format change packet, then return with out checking anything */
+			if (r_pkt->flags & (COMP_FLAG_PIB_VALID | COMP_FLAG_FMT_CHANGE))
+				goto sem_rel_return;
+			if (hw->adp->pdev->device == BC_PCI_DEVID_LINK) {
+				picYcomp = link_GetRptDropParam(hw, hw->PICHeight, hw->PICWidth, (void *)r_pkt);
+			}
+			else {
+				/* For Flea, we don't have the width and height handy since they */
+				/* come in the PIB in the picture, so this function will also */
+				/* populate the width and height */
+				picYcomp = flea_GetRptDropParam(hw, (void *)r_pkt);
+				/* For flea it is the above function that indicated format change */
+				if(r_pkt->flags & (COMP_FLAG_PIB_VALID | COMP_FLAG_FMT_CHANGE))
+					goto sem_rel_return;
+			}
+			if(!picYcomp || (picYcomp == hw->LastPicNo) ||
+				(picYcomp == hw->LastTwoPicNo)) {
+				/*Discard picture */
+				if(picYcomp != 0) {
+					hw->LastTwoPicNo = hw->LastPicNo;
+					hw->LastPicNo = picYcomp;
+				}
+				crystalhd_dioq_add(hw->rx_freeq, r_pkt, false, r_pkt->pkt_tag);
+				r_pkt = NULL;
+				up(&hw->fetch_sem);
+			} else {
+				if(hw->adp->pdev->device == BC_PCI_DEVID_LINK) {
+					if((picYcomp - hw->LastPicNo) > 1) {
+						dev_info(dev, "MISSING %u PICTURES\n", (picYcomp - hw->LastPicNo));
+					}
+				}
+				hw->LastTwoPicNo = hw->LastPicNo;
+				hw->LastPicNo = picYcomp;
+				goto sem_rel_return;
+			}
 		} else if (rc == -EINTR) {
-			BCMLOG(BCMLOG_INFO, "Cancelling fetch wait\n");
 			*sig_pend = 1;
-			return tmp;
+			return r_pkt;
 		}
 		spin_lock_irqsave(&ioq->lock, flags);
-		count--;
 	}
+	dev_info(dev, "FETCH TIMEOUT\n");
 	spin_unlock_irqrestore(&ioq->lock, flags);
-
-out:
-	return crystalhd_dioq_fetch(ioq);
+	return r_pkt;
+sem_error:
+	return NULL;
+sem_rel_return:
+	up(&hw->fetch_sem);
+	return r_pkt;
 }
 
 /**
@@ -686,32 +581,35 @@ enum BC_STATUS crystalhd_map_dio(struct crystalhd_adp *adp, void *ubuff,
 			  bool en_422mode, bool dir_tx,
 			  struct crystalhd_dio_req **dio_hnd)
 {
+	struct device *dev;
 	struct crystalhd_dio_req	*dio;
-	/* FIXME: jarod: should some of these
-	 unsigned longs be uint32_t or uintptr_t? */
-	unsigned long start = 0, end = 0, uaddr = 0, count = 0;
-	unsigned long spsz = 0, uv_start = 0;
+	uint32_t start = 0, end = 0, count = 0;
+	uint32_t spsz = 0;
+	unsigned long uaddr = 0, uv_start = 0;
 	int i = 0, rw = 0, res = 0, nr_pages = 0, skip_fb_sg = 0;
 
 	if (!adp || !ubuff || !ubuff_sz || !dio_hnd) {
-		BCMLOG_ERR("Invalid arg\n");
+		printk(KERN_ERR "%s: Invalid arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
+
+	dev = &adp->pdev->dev;
+
 	/* Compute pages */
 	uaddr = (unsigned long)ubuff;
-	count = (unsigned long)ubuff_sz;
+	count = ubuff_sz;
 	end = (uaddr + count + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	start = uaddr >> PAGE_SHIFT;
 	nr_pages = end - start;
 
 	if (!count || ((uaddr + count) < uaddr)) {
-		BCMLOG_ERR("User addr overflow!!\n");
+		dev_err(dev, "User addr overflow!!\n");
 		return BC_STS_INV_ARG;
 	}
 
 	dio = crystalhd_alloc_dio(adp);
 	if (!dio) {
-		BCMLOG_ERR("dio pool empty..\n");
+		dev_err(dev, "dio pool empty..\n");
 		return BC_STS_INSUFF_RES;
 	}
 
@@ -724,17 +622,16 @@ enum BC_STATUS crystalhd_map_dio(struct crystalhd_adp *adp, void *ubuff,
 	}
 
 	if (nr_pages > dio->max_pages) {
-		BCMLOG_ERR("max_pages(%d) exceeded(%d)!!\n",
-			   dio->max_pages, nr_pages);
+		dev_err(dev, "max_pages(%d) exceeded(%d)!!\n",
+			dio->max_pages, nr_pages);
 		crystalhd_unmap_dio(adp, dio);
 		return BC_STS_INSUFF_RES;
 	}
 
 	if (uv_offset) {
-		uv_start = (uaddr + (unsigned long)uv_offset)  >> PAGE_SHIFT;
+		uv_start = (uaddr + uv_offset)  >> PAGE_SHIFT;
 		dio->uinfo.uv_sg_ix = uv_start - start;
-		dio->uinfo.uv_sg_off = ((uaddr + (unsigned long)uv_offset) &
-					 ~PAGE_MASK);
+		dio->uinfo.uv_sg_off = ((uaddr + uv_offset) & ~PAGE_MASK);
 	}
 
 	dio->fb_size = ubuff_sz & 0x03;
@@ -743,9 +640,9 @@ enum BC_STATUS crystalhd_map_dio(struct crystalhd_adp *adp, void *ubuff,
 				     (void *)(uaddr + count - dio->fb_size),
 				     dio->fb_size);
 		if (res) {
-			BCMLOG_ERR("failed %d to copy %u fill bytes from %p\n",
-				   res, dio->fb_size,
-				   (void *)(uaddr + count-dio->fb_size));
+			dev_err(dev, "failed %d to copy %u fill bytes from %p\n",
+				res, dio->fb_size,
+				(void *)(uaddr + count-dio->fb_size));
 			crystalhd_unmap_dio(adp, dio);
 			return BC_STS_INSUFF_RES;
 		}
@@ -759,7 +656,7 @@ enum BC_STATUS crystalhd_map_dio(struct crystalhd_adp *adp, void *ubuff,
 	/* Save for release..*/
 	dio->sig = crystalhd_dio_locked;
 	if (res < nr_pages) {
-		BCMLOG_ERR("get pages failed: %d-%d\n", nr_pages, res);
+		dev_err(dev, "get pages failed: %d-%d\n", nr_pages, res);
 		dio->page_cnt = res;
 		crystalhd_unmap_dio(adp, dio);
 		return BC_STS_ERROR;
@@ -801,7 +698,7 @@ enum BC_STATUS crystalhd_map_dio(struct crystalhd_adp *adp, void *ubuff,
 	dio->sg_cnt = pci_map_sg(adp->pdev, dio->sg,
 				 dio->page_cnt, dio->direction);
 	if (dio->sg_cnt <= 0) {
-		BCMLOG_ERR("sg map %d-%d\n", dio->sg_cnt, dio->page_cnt);
+		dev_err(dev, "sg map %d-%d\n", dio->sg_cnt, dio->page_cnt);
 		crystalhd_unmap_dio(adp, dio);
 		return BC_STS_ERROR;
 	}
@@ -831,13 +728,13 @@ enum BC_STATUS crystalhd_map_dio(struct crystalhd_adp *adp, void *ubuff,
  * This routine is to unmap the user buffer pages.
  */
 enum BC_STATUS crystalhd_unmap_dio(struct crystalhd_adp *adp,
-				 struct crystalhd_dio_req *dio)
+						struct crystalhd_dio_req *dio)
 {
 	struct page *page = NULL;
 	int j = 0;
 
 	if (!adp || !dio) {
-		BCMLOG_ERR("Invalid arg\n");
+		printk(KERN_ERR "%s: Invalid arg\n", __func__);
 		return BC_STS_INV_ARG;
 	}
 
@@ -853,8 +750,7 @@ enum BC_STATUS crystalhd_unmap_dio(struct crystalhd_adp *adp,
 		}
 	}
 	if (dio->sig == crystalhd_dio_sg_mapped)
-		pci_unmap_sg(adp->pdev, dio->sg, dio->page_cnt,
-			 dio->direction);
+		pci_unmap_sg(adp->pdev, dio->sg, dio->page_cnt, dio->direction);
 
 	crystalhd_free_dio(adp, dio);
 
@@ -874,20 +770,23 @@ enum BC_STATUS crystalhd_unmap_dio(struct crystalhd_adp *adp,
  */
 int crystalhd_create_dio_pool(struct crystalhd_adp *adp, uint32_t max_pages)
 {
+	struct device *dev;
 	uint32_t asz = 0, i = 0;
 	uint8_t	*temp;
 	struct crystalhd_dio_req *dio;
 
 	if (!adp || !max_pages) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		printk(KERN_ERR "%s: Invalid arg\n", __func__);
 		return -EINVAL;
 	}
 
+	dev = &adp->pdev->dev;
+
 	/* Get dma memory for fill byte handling..*/
 	adp->fill_byte_pool = pci_pool_create("crystalhd_fbyte",
 					      adp->pdev, 8, 8, 0);
 	if (!adp->fill_byte_pool) {
-		BCMLOG_ERR("failed to create fill byte pool\n");
+		dev_err(dev, "failed to create fill byte pool\n");
 		return -ENOMEM;
 	}
 
@@ -895,13 +794,13 @@ int crystalhd_create_dio_pool(struct crystalhd_adp *adp, uint32_t max_pages)
 	asz =  (sizeof(*dio->pages) * max_pages) +
 	       (sizeof(*dio->sg) * max_pages) + sizeof(*dio);
 
-	BCMLOG(BCMLOG_DBG, "Initializing Dio pool %d %d %x %p\n",
-	       BC_LINK_SG_POOL_SZ, max_pages, asz, adp->fill_byte_pool);
+	dev_dbg(dev, "Initializing Dio pool %d %d %x %p\n",
+		BC_LINK_SG_POOL_SZ, max_pages, asz, adp->fill_byte_pool);
 
 	for (i = 0; i < BC_LINK_SG_POOL_SZ; i++) {
 		temp = kzalloc(asz, GFP_KERNEL);
 		if ((temp) == NULL) {
-			BCMLOG_ERR("Failed to alloc %d mem\n", asz);
+			dev_err(dev, "Failed to alloc %d mem\n", asz);
 			return -ENOMEM;
 		}
 
@@ -914,7 +813,7 @@ int crystalhd_create_dio_pool(struct crystalhd_adp *adp, uint32_t max_pages)
 		dio->fb_va = pci_pool_alloc(adp->fill_byte_pool, GFP_KERNEL,
 					    &dio->fb_pa);
 		if (!dio->fb_va) {
-			BCMLOG_ERR("fill byte alloc failed.\n");
+			dev_err(dev, "fill byte alloc failed.\n");
 			return -ENOMEM;
 		}
 
@@ -939,7 +838,7 @@ void crystalhd_destroy_dio_pool(struct crystalhd_adp *adp)
 	int count = 0;
 
 	if (!adp) {
-		BCMLOG_ERR("Invalid Arg!!\n");
+		printk(KERN_ERR "%s: Invalid arg\n", __func__);
 		return;
 	}
 
@@ -959,7 +858,7 @@ void crystalhd_destroy_dio_pool(struct crystalhd_adp *adp)
 		adp->fill_byte_pool = NULL;
 	}
 
-	BCMLOG(BCMLOG_DBG, "Released dio pool %d\n", count);
+	dev_dbg(&adp->pdev->dev, "Released dio pool %d\n", count);
 }
 
 /**
@@ -985,12 +884,12 @@ int crystalhd_create_elem_pool(struct crystalhd_adp *adp,
 	for (i = 0; i < pool_size; i++) {
 		temp = kzalloc(sizeof(*temp), GFP_KERNEL);
 		if (!temp) {
-			BCMLOG_ERR("kalloc failed\n");
+			dev_err(&adp->pdev->dev, "kzalloc failed\n");
 			return -ENOMEM;
 		}
 		crystalhd_free_elem(adp, temp);
 	}
-	BCMLOG(BCMLOG_DBG, "allocated %d elem\n", pool_size);
+	dev_dbg(&adp->pdev->dev, "allocated %d elem\n", pool_size);
 	return 0;
 }
 
@@ -1019,25 +918,26 @@ void crystalhd_delete_elem_pool(struct crystalhd_adp *adp)
 		}
 	} while (temp);
 
-	BCMLOG(BCMLOG_DBG, "released %d elem\n", dbg_cnt);
+	dev_dbg(&adp->pdev->dev, "released %d elem\n", dbg_cnt);
 }
 
 /*================ Debug support routines.. ================================*/
 void crystalhd_show_buffer(uint32_t off, uint8_t *buff, uint32_t dwcount)
 {
+	struct device *dev = chddev();
 	uint32_t i, k = 1;
 
 	for (i = 0; i < dwcount; i++) {
 		if (k == 1)
-			BCMLOG(BCMLOG_DATA, "0x%08X : ", off);
+			dev_dbg(dev, "0x%08X : ", off);
 
-		BCMLOG(BCMLOG_DATA, " 0x%08X ", *((uint32_t *)buff));
+		dev_dbg(dev, " 0x%08X ", *((uint32_t *)buff));
 
 		buff += sizeof(uint32_t);
 		off  += sizeof(uint32_t);
 		k++;
 		if ((i == dwcount - 1) || (k > 4)) {
-			BCMLOG(BCMLOG_DATA, "\n");
+			dev_dbg(dev, "\n");
 			k = 1;
 		}
 	}
diff --git a/drivers/staging/crystalhd/crystalhd_misc.h b/drivers/staging/crystalhd/crystalhd_misc.h
index aa736c8..5e00054 100644
--- a/drivers/staging/crystalhd/crystalhd_misc.h
+++ b/drivers/staging/crystalhd/crystalhd_misc.h
@@ -37,10 +37,9 @@
 #include <linux/ioctl.h>
 #include <linux/dma-mapping.h>
 #include <linux/sched.h>
-#include "bc_dts_glob_lnx.h"
 
-/* Global log level variable defined in crystal_misc.c file */
-extern uint32_t g_linklog_level;
+/* forward declare */
+struct crystalhd_hw;
 
 /* Global element pool for all Queue management.
  * TX: Active = BC_TX_LIST_CNT, Free = BC_TX_LIST_CNT.
@@ -89,16 +88,18 @@ struct crystalhd_dio_req {
 	void				*fb_va;
 	uint32_t			fb_size;
 	dma_addr_t			fb_pa;
+	/* pointer to temporary buffer to extract metadata */
+	void				*pib_va;
 	struct crystalhd_dio_req	*next;
 };
 
 #define BC_LINK_DIOQ_SIG	(0x09223280)
 
 struct crystalhd_elem {
-	struct crystalhd_elem	*flink;
-	struct crystalhd_elem	*blink;
-	void			*data;
-	uint32_t		tag;
+	struct crystalhd_elem		*flink;
+	struct crystalhd_elem		*blink;
+	void				*data;
+	uint32_t			tag;
 };
 
 typedef void (*crystalhd_data_free_cb)(void *context, void *data);
@@ -106,8 +107,8 @@ typedef void (*crystalhd_data_free_cb)(void *context, void *data);
 struct crystalhd_dioq {
 	uint32_t		sig;
 	struct crystalhd_adp	*adp;
-	struct crystalhd_elem		*head;
-	struct crystalhd_elem		*tail;
+	struct crystalhd_elem	*head;
+	struct crystalhd_elem	*tail;
 	uint32_t		count;
 	spinlock_t		lock;
 	wait_queue_head_t	event;
@@ -118,25 +119,11 @@ struct crystalhd_dioq {
 typedef void (*hw_comp_callback)(struct crystalhd_dio_req *,
 				 wait_queue_head_t *event, enum BC_STATUS sts);
 
-/*========= Decoder (7412) register access routines.================= */
-uint32_t bc_dec_reg_rd(struct crystalhd_adp *, uint32_t);
-void bc_dec_reg_wr(struct crystalhd_adp *, uint32_t, uint32_t);
-
-/*========= Link (70012) register access routines.. =================*/
-uint32_t crystalhd_reg_rd(struct crystalhd_adp *, uint32_t);
-void crystalhd_reg_wr(struct crystalhd_adp *, uint32_t, uint32_t);
-
-/*========= Decoder (7412) memory access routines..=================*/
-enum BC_STATUS crystalhd_mem_rd(struct crystalhd_adp *,
-			 uint32_t, uint32_t, uint32_t *);
-enum BC_STATUS crystalhd_mem_wr(struct crystalhd_adp *,
-			 uint32_t, uint32_t, uint32_t *);
-
-/*==========Link (70012) PCIe Config access routines.================*/
+/*========== PCIe Config access routines.================*/
 enum BC_STATUS crystalhd_pci_cfg_rd(struct crystalhd_adp *,
-			 uint32_t, uint32_t, uint32_t *);
+                            uint32_t, uint32_t, uint32_t *);
 enum BC_STATUS crystalhd_pci_cfg_wr(struct crystalhd_adp *,
-			 uint32_t, uint32_t, uint32_t);
+                            uint32_t, uint32_t, uint32_t);
 
 /*========= Linux Kernel Interface routines. ======================= */
 void *bc_kern_dma_alloc(struct crystalhd_adp *, uint32_t, dma_addr_t *);
@@ -147,11 +134,11 @@ void bc_kern_dma_free(struct crystalhd_adp *, uint32_t,
 #define crystalhd_wait_on_event(ev, condition, timeout, ret, nosig)	\
 do {									\
 	DECLARE_WAITQUEUE(entry, current);				\
-	unsigned long end = jiffies + ((timeout * HZ) / 1000);		\
+	unsigned long end = jiffies + msecs_to_jiffies(timeout);		\
 		ret = 0;						\
 	add_wait_queue(ev, &entry);					\
-	for (;;) {							\
-		__set_current_state(TASK_INTERRUPTIBLE);		\
+	for (;;) {									\
+		set_current_state(TASK_INTERRUPTIBLE);		\
 		if (condition) {					\
 			break;						\
 		}							\
@@ -165,7 +152,7 @@ do {									\
 			break;						\
 		}							\
 	}								\
-	__set_current_state(TASK_RUNNING);				\
+	set_current_state(TASK_RUNNING);				\
 	remove_wait_queue(ev, &entry);					\
 } while (0)
 
@@ -190,7 +177,7 @@ extern enum BC_STATUS crystalhd_dioq_add(struct crystalhd_dioq *ioq,
 extern void *crystalhd_dioq_fetch(struct crystalhd_dioq *ioq);
 extern void *crystalhd_dioq_find_and_fetch(struct crystalhd_dioq *ioq,
 		 uint32_t tag);
-extern void *crystalhd_dioq_fetch_wait(struct crystalhd_dioq *ioq,
+extern void *crystalhd_dioq_fetch_wait(struct crystalhd_hw *hw,
 		 uint32_t to_secs, uint32_t *sig_pend);
 
 #define crystalhd_dioq_count(_ioq)	((_ioq) ? _ioq->count : 0)
@@ -198,35 +185,8 @@ extern void *crystalhd_dioq_fetch_wait(struct crystalhd_dioq *ioq,
 extern int crystalhd_create_elem_pool(struct crystalhd_adp *, uint32_t);
 extern void crystalhd_delete_elem_pool(struct crystalhd_adp *);
 
-
 /*================ Debug routines/macros .. ================================*/
 extern void crystalhd_show_buffer(uint32_t off, uint8_t *buff,
 		 uint32_t dwcount);
 
-enum _chd_log_levels {
-	BCMLOG_ERROR		= 0x80000000,	/* Don't disable this option */
-	BCMLOG_DATA		= 0x40000000,	/* Data, enable by default */
-	BCMLOG_SPINLOCK		= 0x20000000,	/* Spcial case for Spin locks*/
-
-	/* Following are allowed only in debug mode */
-	BCMLOG_INFO		= 0x00000001,	/* Generic informational */
-	BCMLOG_DBG		= 0x00000002,	/* First level Debug info */
-	BCMLOG_SSTEP		= 0x00000004,	/* Stepping information */
-};
-
-
-#define BCMLOG(trace, fmt, args...)	\
-do {					\
-	if (g_linklog_level & trace)	\
-		printk(fmt, ##args);	\
-} while (0)
-
-
-#define BCMLOG_ERR(fmt, args...)				\
-do {								\
-	if (g_linklog_level & BCMLOG_ERROR)			\
-		printk(KERN_ERR "*ERR*:%s:%d: "fmt,		\
-				__FILE__, __LINE__, ##args);	\
-} while (0)
-
 #endif
-- 
1.8.4


