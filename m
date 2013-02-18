Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab3BRJzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 04:55:20 -0500
Received: from mysmtp1.stec-inc.com ([1.9.68.9]:41075 "HELO
	mysmtp1.stec-inc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752854Ab3BRJzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 04:55:16 -0500
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Feb 2013 04:55:05 EST
X-ASG-Debug-ID: 1361180696-053ea90dcf2b6e20001-xx1T2L
X-Barracuda-Envelope-From: sunnikrishnan@stec-inc.com
X-Barracuda-RBL-Trusted-Forwarder: 172.30.0.57
From: Sanoj Unnikrishnan <sunnikrishnan@stec-inc.com>
X-Barracuda-BWL-IP: fe80::748e:376a:ee63:5279
X-Barracuda-Apparent-Source-IP: fe80::748e:376a:ee63:5279
To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        OS Engineering <osengineering@stec-inc.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        =?iso-2022-jp?B?GyRCMiY2YjE6GyhC?= <jinpuwang@gmail.com>,
        Amit Kale <akale@stec-inc.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "koverstreet@google.com" <koverstreet@google.com>,
        "thornber@redhat.com" <thornber@redhat.com>
Date: Mon, 18 Feb 2013 17:42:38 +0800
Subject: RE: [PATCH] EnhanceIO ssd caching software
Thread-Topic: [PATCH] EnhanceIO ssd caching software
X-ASG-Orig-Subj: RE: [PATCH] EnhanceIO ssd caching software
Thread-Index: Ac4Lu3Y5Pp0aO1WDSlSaKpyUfPKjfgB+fG+g
Message-ID: <C4B5704C6FEB5244B2A1BCC8CF83B86B0C746B4948@MYMBX.MY.STEC-INC.AD>
References: <C4B5704C6FEB5244B2A1BCC8CF83B86B0A624D6AAF@MYMBX.MY.STEC-INC.AD>
 <20130215203139.GE26292@blackbox.djwong.org>
In-Reply-To: <20130215203139.GE26292@blackbox.djwong.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: mycas01.my.stec-inc.ad[172.30.0.57]
X-Barracuda-Start-Time: 1361180696
X-Barracuda-URL: http://myspam1.stec-inc.com:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -0.00
X-Barracuda-Spam-Status: No, SCORE=-0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=ISO2022JP_CHARSET
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.123005
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	-0.00 ISO2022JP_CHARSET      ISO-2022-JP message
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Darrick J. Wong [mailto:darrick.wong@oracle.com]
> Sent: Saturday, February 16, 2013 2:02 AM
> To: OS Engineering
> Cc: Greg Kroah-Hartman; LKML; Jens Axboe; Sanoj Unnikrishnan; 王金浦;
> Amit Kale; dm-devel@redhat.com; koverstreet@google.com;
> thornber@redhat.com
> Subject: Re: [PATCH] EnhanceIO ssd caching software
> 
> [Resending with dm-devel, Kent, and Joe on cc.  Sorry for the noise.]
> 
> On Fri, Feb 15, 2013 at 02:02:38PM +0800, OS Engineering wrote:
> > Hi Greg, Jens,
> >
> > We are submitting EnhanceIO(TM) software driver for an inclusion in
> linux
> > staging tree. Present state of this driver is beta. We have been
> posting it
> > for a few weeks, while it was maintained at github. It is still being
> > cleaned-up and is being tested by LKML members. Inclusion in linux
> staging
> > tree will make testing and reviewing easier and help a future
> integration in
> > Linux kernel.
> >
> > Could you please include it?

> >
> > Signed-off-by:
> > Amit Kale <akale@stec-inc.com>
> > Sanoj Unnikrishnan <sunnikrishnan@stec-inc.com>
> > Darrick J. Wong <darrick.wong@oracle.com>
> > Jinpu Wang <jinpuwang@gmail.com>
> 
> Each of these email addresses needs to have the "S-o-b:" prefix

> Also, you ought to run this patch through scripts/checkpatch.pl, as
> there are
> quite a lot of style errors.

we will fix these in the next patch.


> > +ACTION!="add|change", GOTO="EIO_EOF"
> > +SUBSYSTEM!="block", GOTO="EIO_EOF"
> > +
> > +<cache_match_expr>, GOTO="EIO_CACHE"
> > +
> > +<source_match_expr>, GOTO="EIO_SOURCE"
> > +
> > +# If none of the rules above matched then it isn't an EnhanceIO
> device so ignore it.
> > +GOTO="EIO_EOF"
> > +
> > +# If we just found the cache device and the source already exists
> then we can setup
> > +LABEL="EIO_CACHE"
> > +       TEST!="/dev/enhanceio/<cache_name>", PROGRAM="/bin/mkdir -p
> /dev/enhanceio/<cache_name>"
> > +       PROGRAM="/bin/sh -c 'echo $kernel >
> /dev/enhanceio/<cache_name>/.ssd_name'"
> > +
> > +       TEST=="/dev/enhanceio/<cache_name>/.disk_name",
> GOTO="EIO_SETUP"
> > +GOTO="EIO_EOF"
> > +
> > +# If we just found the source device and the cache already exists
> then we can setup
> > +LABEL="EIO_SOURCE"
> > +       TEST!="/dev/enhanceio/<cache_name>", PROGRAM="/bin/mkdir -p
> /dev/enhanceio/<cache_name>"
> > +       PROGRAM="/bin/sh -c 'echo $kernel >
> /dev/enhanceio/<cache_name>/.disk_name'"
> > +
> > +       TEST=="/dev/enhanceio/<cache_name>/.ssd_name",
> GOTO="EIO_SETUP"
> 
> If the cache is running in wb mode, perhaps we should make it ro until
> the SSD
> shows up and we run eio_cli?  Run blockdev --setro in the EIO_CACHE
> part, and
> blockdev --setrw in the EIO_SOURCE part?
> 
> <shrug> not a udev developer, take that with a grain of salt.

We were exploring hiding source node as an option. This seems to be better.
 
> > +How to create persistent cache
> > +==============================
> > +
> > +Use the 94-Enhanceio-template file to create a per cache udev-rule
> file named /etc/udev/rules.d/94-enhancio-<cache_name>.rules
> > +
> > +1) Change <cache_match_expr> to ENV{ID_SERIAL}=="<ID SERIAL OF YOUR
> CACHE DEVICE>", ENV{DEVTYPE}==<DEVICE TYPE OF YOUR CACHE DEVICE>
> > +
> > +2) Change <source_match_expr> to ENV{ID_SERIAL}=="<ID SERIAL OF YOUR
> HARD DISK>", ENV{DEVTYPE}==<DEVICE TYPE OF YOUR SOURCE DEVICE>
> > +
> > +3) Replace all instances of <cache_name> with the name of your cache
> 
> I wonder if there's a better way to do this than manually cutting and
> pasting
> all these IDs into a udev rules file.  Or, how about a quick script at
> cache
> creation time that spits out files into /etc/udev/rules.d/ ?

agreed!! Will add one in the next patch.

> > +       Write-back improves write latency by writing application
> requested data
> > +       only to SSD. This data, referred to as dirty data, is copied
> later to
> 
> How much later?
>

This is triggered by a set of thresholds.
per cache dirty high and low watermark.
per cache set dirty high and low watermark.
and a time based threshold.
If any of the high watermarks or time based interval is triggered clean is initiated.

These thresholds are all configurable through sysctl.

> > +       Failure of an SSD device in write-back mode obviously results
> in the
> > +       loss of dirty blocks in the cache. To guard against this data
> loss, two
> > +       SSD devices can be mirrored via RAID 1.
> 
> What happens to writes that happen after the SSD goes down?  Are they
> simply
> passed through to the slow disk?


It does so in the current code. Maybe, we could make the source device read only and
change it to read-write only cache deletion.

> > +#if defined(__KERNEL__) && !defined(CONFIG_PROC_FS)
> > +#error "EnhanceIO requires CONFIG_PROC_FS"
> > +#endif                          /* __KERNEL__ && !CONFIG_PROC_FS */
> 
> This dependency should be stated in the Kconfig file.  'depends
> PROC_FS' or
> something like that.

Will fix this!

> > +struct eio_control_s {
> > +       volatile unsigned long synch_flags;
> 
> Are you sure that this volatile does what you think it does?
> http://www.kernel.org/doc/Documentation/volatile-considered-harmful.txt
> 
> afaict all the uses of synch_flags seem to use atomic operations
> already...
> 
> > +};

Use of volatiles in Enhanceio is very similar to use of jiffies. However,
we will consider replacing them.


> > + * This file has three sections as follows:
> > + *
> > + *      Section 1: User space only
> > + *      Section 2: User space and kernel
> > + *      Section 3: Kernel only
> > + *
> > + * Each section may contain its own subsections.
> > + */
> > +
> > +/*
> > + * Begin Section 1: User space only.
> > + */
> 
> Empty?

Yes, Need to figure out how to include C header file in python (looking at cffi module,
for this purpose). Certain constants and structures such as ioctl numbers and structure
have to be moved here. Currently it is duplicated.

> > +/*
> > + * End Section 1: User space only.
> > + */
> > +
> > +/*
> > + * Begin Section 2: User space and kernel.
> > + */
> > +
> > +/* States of a cache block */
> > +#define INVALID                 0x0001
> > +#define VALID                   0x0002  /* Valid */
> > +#define DISKREADINPROG          0x0004  /* Read from disk in
> progress */
> > +#define DISKWRITEINPROG         0x0008  /* Write to disk in progress
> */
> > +#define CACHEREADINPROG         0x0010  /* Read from cache in
> progress */
> > +#define CACHEWRITEINPROG        0x0020  /* Write to cache in
> progress */
> > +#define DIRTY                   0x0040  /* Dirty, needs writeback to
> disk */
> > +#define QUEUED                  0x0080  /* Other requests are queued
> for this block */
> > +
> > +#define BLOCK_IO_INPROG (DISKREADINPROG | DISKWRITEINPROG | \
> > +                        CACHEREADINPROG | CACHEWRITEINPROG)
> > +#define DIRTY_INPROG    (VALID | DIRTY | CACHEWRITEINPROG)      /*
> block being dirtied */
> > +#define CLEAN_INPROG    (VALID | DIRTY | DISKWRITEINPROG)       /*
> ongoing clean */
> > +#define ALREADY_DIRTY   (VALID | DIRTY)                         /*
> block which is dirty to begin with for an I/O */
> 
> These shouldn't go past 80 columns.
> 
> > +/*
> > + * This is a special state used only in the following scenario as
> > + * part of device (SSD) failure handling:
> > + *
> > + * ------| dev fail |------| dev resume |------------
> > + *   ...-<--- Tf --><- Td -><---- Tr ---><-- Tn ---...
> > + * |---- Normal ----|-- Degraded -------|-- Normal ---|
> > + *
> > + * Tf: Time during device failure.
> > + * Td: Time after failure when the cache is in degraded mode.
> > + * Tr: Time when the SSD comes back online.
> > + *
> > + * When a failed SSD is added back again, it should be treated
> > + * as a cold SSD.
> > + *
> > + * If Td is very small, then there can be IOs that were initiated
> > + * before or during Tf, and did not finish until the end of Tr.
> From
> > + * the IO's viewpoint, the SSD was there when the IO was initiated
> > + * and it was there when the IO was finished.  These IOs need
> special
> > + * handling as described below.
> > + *
> > + * To add the SSD as a cold cache device, we initialize all blocks
> > + * to INVALID, execept for the ones that had IOs in progress before
> > + * or during Tf.  We mark such blocks as both VALID and INVALID.
> > + * These blocks will be marked INVALID when finished.
> > + */
> > +#define NO_SSD_IO_INPROG        (VALID | INVALID)
> > +
> > +/*
> > + * On Flash (cache metadata) Structures
> > + */
> > +#define CACHE_MD_STATE_DIRTY            0x55daddee
> > +#define CACHE_MD_STATE_CLEAN            0xacceded1
> > +#define CACHE_MD_STATE_FASTCLEAN        0xcafebabf
> > +#define CACHE_MD_STATE_UNSTABLE         0xdeaddeee
> > +
> > +/* Do we have a read cache or a read-write cache */
> > +#define CACHE_MODE_WB           1
> > +#define CACHE_MODE_RO           2
> > +#define CACHE_MODE_WT           3
> > +#define CACHE_MODE_FIRST        CACHE_MODE_WB
> > +#define CACHE_MODE_LAST         CACHE_MODE_WT
> > +#define CACHE_MODE_DEFAULT      CACHE_MODE_WT
> > +
> > +#define DEV_PATHLEN             128
> > +#define EIO_SUPERBLOCK_SIZE     4096
> > +
> > +#define EIO_CLEAN_ABORT         0x00000000
> > +#define EIO_CLEAN_START         0x00000001
> > +#define EIO_CLEAN_KEEP          0x00000002
> > +
> > +/* EIO magic number */
> > +#define EIO_MAGIC               0xE10CAC6E
> > +#define EIO_BAD_MAGIC           0xBADCAC6E
> > +
> > +/* EIO version */
> > +#define EIO_SB_VERSION          3       /* kernel superblock version
> */
> > +#define EIO_SB_MAGIC_VERSION    3       /* version in which magic
> number was introduced */
> > +
> > +typedef union eio_superblock {
> > +       struct superblock_fields {
> > +               sector_t size;                  /* Cache size */
> 
> sector_t is 32 bits on !LBDAF 32-bit systems and 64 bits otherwise.
> This
> structure seems reflect an on-disk format, which means that I can badly
> screw
> things up if I move a cache disk between machines with differently
> configured
> kernels.  Plus, if we ever change the definition of sector_t then this
> structure will be broken.
> 
> This field should be declared with an explicit size, i.e. __le64.
> 
> > +               u_int32_t block_size;           /* Cache block size
> */
> 
> Worse yet, these fields should use endianness notations (e.g. __le32)
> and when
> you write out the superblock, you need to wrap the assignments with a
> cpu_to_leXX() call.  Otherwise, enhanceio caches created on ppc64 won't
> load on
> a x64 box (and vice versa) because all the bytes are swapped.
> 
> These two grumblings also apply to any other on-disk-format structs in
> this
> patch.

Will fix these ASAP.


> 
> > +               u_int32_t assoc;                /* Cache
> associativity */
> > +               u_int32_t cache_sb_state;       /* Clean shutdown ?
> */
> > +               char cache_devname[DEV_PATHLEN];
> > +               sector_t cache_devsize;
> > +               char disk_devname[DEV_PATHLEN];
> > +               sector_t disk_devsize;
> > +               u_int32_t cache_version;
> > +               char cache_name[DEV_PATHLEN];
> > +               u_int32_t mode;
> > +               u_int32_t repl_policy;
> > +               u_int32_t cache_flags;
> > +               /*
> > +                * Version 1.1 superblock ends here.
> > +                * Don't modify any of the above fields.
> > +                */
> > +               u_int32_t magic;                /* Has to be the 1st
> field afer 1.1 superblock */
> > +               u_int32_t cold_boot;            /* cache to be
> started as cold after boot */
> > +               char ssd_uuid[DEV_PATHLEN];
> > +               sector_t cache_md_start_sect;   /* cache metadata
> start (8K aligned) */
> > +               sector_t cache_data_start_sect; /* cache data start
> (8K aligned) */
> > +               u_int32_t dirty_high_threshold;
> > +               u_int32_t dirty_low_threshold;
> > +               u_int32_t dirty_set_high_threshold;
> > +               u_int32_t dirty_set_low_threshold;
> > +               u_int32_t time_based_clean_interval;
> > +               u_int32_t autoclean_threshold;
> > +       } sbf;
> > +       u_int8_t padding[EIO_SUPERBLOCK_SIZE];
> > +} eio_superblock_t;
> 
> Why does this in-memory data structure need to be 4096 bytes long?
> 'padding'
> doesn't seem to be used anywhere.

We have assumed that superblock would require at most 4096 bytes (considering future
Additions too). 
 
> > + * Rethink on max, min, default values
> > + */
> > +#define DIRTY_HIGH_THRESH_DEF           30
> > +#define DIRTY_LOW_THRESH_DEF            10
> > +#define DIRTY_SET_HIGH_THRESH_DEF       100
> > +#define DIRTY_SET_LOW_THRESH_DEF        30
> 
> What are the units of these values?  I suspect that they're used to
> decide when
> to start (and stop) flushing dirty blocks out of a wb cache, but please
> write
> down in Documentation/enhanceio/README.txt or somewhere what the sysctl
> values
> do, and in what units they are expressed.

These are the auto clean thresholds (mentioned previously in the mail).
Will update the Documentation.

> > +#include "eio_ioctl.h"
> > +
> > +/* resolve conflict with scsi/scsi_device.h */
> > +#ifdef __KERNEL__
> > +#ifdef VERIFY
> > +#undef VERIFY
> > +#endif
> > +#define ENABLE_VERIFY
> > +#ifdef ENABLE_VERIFY
> > +/* Like ASSERT() but always compiled in */
> > +#define VERIFY(x) do { \
> > +               if (unlikely(!(x))) { \
> > +                       dump_stack(); \
> > +                       panic("VERIFY: assertion (%s) failed at %s
> (%d)\n", \
> > +                             # x,  __FILE__, __LINE__);
> \
> > +               } \
> > +} while (0)
> > +#else                           /* ENABLE_VERIFY */
> > +#define VERIFY(x) do { } while (0);
> > +#endif                          /* ENABLE_VERIFY */
> 
> BUG_ON()?
> 

Will Fix this
 
> Ooookay, that's enough, I need a break, I'll review more later.
> 
> --D

Sure,  Thanks for the elaborate review.
Sanoj

PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED



This electronic transmission, and any documents attached hereto, may contain confidential, proprietary and/or legally privileged information. The information is intended only for use by the recipient named above. If you received this electronic message in error, please notify the sender and delete the electronic message. Any disclosure, copying, distribution, or use of the contents of information received in error is strictly prohibited, and violators will be pursued legally.
