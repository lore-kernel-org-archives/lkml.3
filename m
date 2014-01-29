Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaA2Mwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 07:52:46 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:39283 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaA2Mwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 07:52:44 -0500
Message-ID: <1390999955.2601.22.camel@snow.station>
Subject: same ext4 file system corruption on different machines
From: Luca Ognibene <luca.ognibene@gmail.com>
To: linux-kernel@vger.kernel.org
Date: Wed, 29 Jan 2014 13:52:35 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, we are using ext4 as the root file system of some servers(~100, the
first installed 5 months ago). We are starting to see corruption on
these file systems, it already happened 3 times. All these servers have
the same image copied on the 4GB disk-on-module sata disk. They don't
write very much on the disk, only upgrades from time to time and
configuration files written 3 times a day,a couple of MB each time. Logs
are written on another partition. The faulty servers have different
motherboard/cpu(intel 64bit). We are running ubuntu 12.04.2 with kernel
3.8.0-31-generic. We used the same dom with another image and ext3
without problems for a couple of years so i don't think it's a dom's
fault.
And now the problem.. this is e2fsck -n /device (i've created an image
and running tools against it, this is why you see /dev/mapper/loop1p2)

e2fsck 1.42 (29-Nov-2011)
/dev/mapper/loop1p2 contains a file system with errors, check forced.
Pass 1: Checking inodes, blocks, and sizes
Inode 127233 is in use, but has dtime set.  Fix? no

Inode 127233 has imagic flag set.  Clear? no

Inode 127233 has a extra size (65535) which is invalid
Fix? no

Inode 127233 has compression flag set on filesystem without compression support.  Clear? no

Inode 127233 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 127233 has an invalid root node.
Clear HTree index? no

Inode 127233 should not have EOFBLOCKS_FL set (size 18446744073709551615, lblk -1)
Clear? no

Inode 127233, i_size is 18446744073709551615, should be 0.  Fix? no

Inode 127233, i_blocks is 281474976710655, should be 0.  Fix? no

Inode 127234 is in use, but has dtime set.  Fix? no

Inode 127234 has imagic flag set.  Clear? no

Inode 127234 has a extra size (65535) which is invalid
Fix? no

Inode 127234 has compression flag set on filesystem without compression support.  Clear? no

Inode 127234 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 127234 has an invalid root node.
Clear HTree index? no

Inode 127234 should not have EOFBLOCKS_FL set (size 18446744073709551615, lblk -1)
Clear? no

Inode 127234, i_size is 18446744073709551615, should be 0.  Fix? no

Inode 127234, i_blocks is 281474976710655, should be 0.  Fix? no

Inode 127235 is in use, but has dtime set.  Fix? no

Inode 127235 has imagic flag set.  Clear? no

Inode 127235 has a extra size (65535) which is invalid
Fix? no

Inode 127235 has compression flag set on filesystem without compression support.  Clear? no

Inode 127235 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 127235 has an invalid root node.
Clear HTree index? no

Inode 127235 should not have EOFBLOCKS_FL set (size 18446744073709551615, lblk -1)
Clear? no

Inode 127235, i_size is 18446744073709551615, should be 0.  Fix? no

Inode 127235, i_blocks is 281474976710655, should be 0.  Fix? no

Inode 127236 is in use, but has dtime set.  Fix? no

Inode 127236 has imagic flag set.  Clear? no

Inode 127236 has a extra size (65535) which is invalid
Fix? no

Inode 127236 has compression flag set on filesystem without compression support.  Clear? no

Inode 127236 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 127236 has an invalid root node.
Clear HTree index? no

Inode 127236 should not have EOFBLOCKS_FL set (size 18446744073709551615, lblk -1)
Clear? no

Inode 127236, i_size is 18446744073709551615, should be 0.  Fix? no

Inode 127236, i_blocks is 281474976710655, should be 0.  Fix? no

Inode 127237 is in use, but has dtime set.  Fix? no

Inode 127237 has imagic flag set.  Clear? no

Inode 127237 has a extra size (65535) which is invalid
Fix? no

Inode 127237 has compression flag set on filesystem without compression support.  Clear? no

Inode 127237 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 127237 has an invalid root node.
Clear HTree index? no

Inode 127237 should not have EOFBLOCKS_FL set (size 18446744073709551615, lblk -1)
Clear? no

Inode 127237, i_size is 18446744073709551615, should be 0.  Fix? no

Inode 127237, i_blocks is 281474976710655, should be 0.  Fix? no

Inode 127238 is in use, but has dtime set.  Fix? no

Inode 127238 has imagic flag set.  Clear? no

Inode 127238 has a extra size (65535) which is invalid
Fix? no

Inode 127238 has compression flag set on filesystem without compression support.  Clear? no

Inode 127238 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 127238 has an invalid root node.
Clear HTree index? no

Inode 127238 should not have EOFBLOCKS_FL set (size 18446744073709551615, lblk -1)
Clear? no

Inode 127238, i_size is 18446744073709551615, should be 0.  Fix? no

Inode 127238, i_blocks is 281474976710655, should be 0.  Fix? no

Inode 127239 is in use, but has dtime set.  Fix? no

Inode 127239 has imagic flag set.  Clear? no

Inode 127239 has a extra size (65535) which is invalid
Fix? no

Inode 127239 has compression flag set on filesystem without compression support.  Clear? no

Inode 127239 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 127239 has an invalid root node.
Clear HTree index? no

Inode 127239 should not have EOFBLOCKS_FL set (size 18446744073709551615, lblk -1)
Clear? no

Inode 127239, i_size is 18446744073709551615, should be 0.  Fix? no

Inode 127239, i_blocks is 281474976710655, should be 0.  Fix? no

Inode 127240 is in use, but has dtime set.  Fix? no

Inode 127240 has imagic flag set.  Clear? no

Inode 127240 has a extra size (65535) which is invalid
Fix? no

Inode 127240 has compression flag set on filesystem without compression support.  Clear? no

Inode 127240 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 127240 has an invalid root node.
Clear HTree index? no

Inode 127240 should not have EOFBLOCKS_FL set (size 18446744073709551615, lblk -1)
Clear? no

Inode 127240, i_size is 18446744073709551615, should be 0.  Fix? no

Inode 127240, i_blocks is 281474976710655, should be 0.  Fix? no

Inode 127241 is in use, but has dtime set.  Fix? no

Inode 127241 has imagic flag set.  Clear? no

Inode 127241 has a extra size (65535) which is invalid
Fix? no

Inode 127241 has compression flag set on filesystem without compression support.  Clear? no

Inode 127241 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 127241 has an invalid root node.
Clear HTree index? no

Inode 127241 should not have EOFBLOCKS_FL set (size 18446744073709551615, lblk -1)
Clear? no

Inode 127241, i_size is 18446744073709551615, should be 0.  Fix? no

Inode 127241, i_blocks is 281474976710655, should be 0.  Fix? no

Inode 127242 is in use, but has dtime set.  Fix? no

Inode 127242 has imagic flag set.  Clear? no

Inode 127242 has a extra size (65535) which is invalid
Fix? no

Inode 127242 has compression flag set on filesystem without compression support.  Clear? no

Inode 127242 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 127242 has an invalid root node.
Clear HTree index? no

Inode 127242 should not have EOFBLOCKS_FL set (size 18446744073709551615, lblk -1)
Clear? no

Inode 127242, i_size is 18446744073709551615, should be 0.  Fix? no

Inode 127242, i_blocks is 281474976710655, should be 0.  Fix? no

Inode 127243 is in use, but has dtime set.  Fix? no

Inode 127243 has imagic flag set.  Clear? no

Inode 127243 has a extra size (65535) which is invalid
Fix? no

Inode 127243 has compression flag set on filesystem without compression support.  Clear? no

Inode 127243 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 127243 has an invalid root node.
Clear HTree index? no

Inode 127243 should not have EOFBLOCKS_FL set (size 18446744073709551615, lblk -1)
Clear? no

Inode 127243, i_size is 18446744073709551615, should be 0.  Fix? no

Inode 127243, i_blocks is 281474976710655, should be 0.  Fix? no

Inode 127244 is in use, but has dtime set.  Fix? no

Inode 127244 has imagic flag set.  Clear? no

Inode 127244 has a extra size (65535) which is invalid
Fix? no

Inode 127244 has compression flag set on filesystem without compression support.  Clear? no

Inode 127244 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 127244 has an invalid root node.
Clear HTree index? no

Inode 127244 should not have EOFBLOCKS_FL set (size 18446744073709551615, lblk -1)
Clear? no

Inode 127244, i_size is 18446744073709551615, should be 0.  Fix? no

Inode 127244, i_blocks is 281474976710655, should be 0.  Fix? no

Inode 127245 is in use, but has dtime set.  Fix? no

Inode 127245 has imagic flag set.  Clear? no

Inode 127245 has a extra size (65535) which is invalid
Fix? no

Inode 127245 has compression flag set on filesystem without compression support.  Clear? no

Inode 127245 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 127245 has an invalid root node.
Clear HTree index? no

Inode 127245 should not have EOFBLOCKS_FL set (size 18446744073709551615, lblk -1)
Clear? no

Inode 127245, i_size is 18446744073709551615, should be 0.  Fix? no

Inode 127245, i_blocks is 281474976710655, should be 0.  Fix? no

Inode 127246 is in use, but has dtime set.  Fix? no

Inode 127246 has imagic flag set.  Clear? no

Inode 127246 has a extra size (65535) which is invalid
Fix? no

Inode 127246 has compression flag set on filesystem without compression support.  Clear? no

Inode 127246 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 127246 has an invalid root node.
Clear HTree index? no

Inode 127246 should not have EOFBLOCKS_FL set (size 18446744073709551615, lblk -1)
Clear? no

Inode 127246, i_size is 18446744073709551615, should be 0.  Fix? no

Inode 127246, i_blocks is 281474976710655, should be 0.  Fix? no

Inode 127247 is in use, but has dtime set.  Fix? no

Inode 127247 has imagic flag set.  Clear? no

Inode 127247 has a extra size (65535) which is invalid
Fix? no

Inode 127247 has compression flag set on filesystem without compression support.  Clear? no

Inode 127247 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 127247 has an invalid root node.
Clear HTree index? no

Inode 127247 should not have EOFBLOCKS_FL set (size 18446744073709551615, lblk -1)
Clear? no

Inode 127247, i_size is 18446744073709551615, should be 0.  Fix? no

Inode 127247, i_blocks is 281474976710655, should be 0.  Fix? no

Inode 127248 is in use, but has dtime set.  Fix? no

Inode 127248 has imagic flag set.  Clear? no

Inode 127248 has a extra size (65535) which is invalid
Fix? no

Inode 127248 has compression flag set on filesystem without compression support.  Clear? no

Inode 127248 has INDEX_FL flag set but is not a directory.
Clear HTree index? no

HTREE directory inode 127248 has an invalid root node.
Clear HTree index? no

Inode 127248 should not have EOFBLOCKS_FL set (size 18446744073709551615, lblk -1)
Clear? no

Inode 127248, i_size is 18446744073709551615, should be 0.  Fix? no

Inode 127248, i_blocks is 281474976710655, should be 0.  Fix? no

Pass 2: Checking directory structure
Inode 127233 (/lib/x86_64-linux-gnu) has invalid mode (0177777).
Clear? no

i_faddr for inode 127233 (/lib/x86_64-linux-gnu) is 4294967295, should be zero.
Clear? no

i_file_acl_hi for inode 127233 (/lib/x86_64-linux-gnu) is 65535, should be zero.
Clear? no

Extended attribute block for inode 127233 (/lib/x86_64-linux-gnu) is invalid (4294967295).
Clear? no

Entry 'x86_64-linux-gnu' in /lib (2659) has an incorrect filetype (was 2, should be 0).
Fix? no

Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Inode 2659 ref count is 19, should be 18.  Fix? no

Inode 127233 ref count is 65535, should be 1.  Fix? no

Inode 127234 (...) has invalid mode (0177777).
Clear? no

i_faddr for inode 127234 (...) is 4294967295, should be zero.
Clear? no

i_file_acl_hi for inode 127234 (...) is 65535, should be zero.
Clear? no

Extended attribute block for inode 127234 (...) is invalid (4294967295).
Clear? no

Unattached inode 127234
Connect to /lost+found? no

Inode 127235 (...) has invalid mode (0177777).
Clear? no

i_faddr for inode 127235 (...) is 4294967295, should be zero.
Clear? no

i_file_acl_hi for inode 127235 (...) is 65535, should be zero.
Clear? no

Extended attribute block for inode 127235 (...) is invalid (4294967295).
Clear? no

Unattached inode 127235
Connect to /lost+found? no

Inode 127236 (...) has invalid mode (0177777).
Clear? no

i_faddr for inode 127236 (...) is 4294967295, should be zero.
Clear? no

i_file_acl_hi for inode 127236 (...) is 65535, should be zero.
Clear? no

Extended attribute block for inode 127236 (...) is invalid (4294967295).
Clear? no

Unattached inode 127236
Connect to /lost+found? no

Inode 127237 (...) has invalid mode (0177777).
Clear? no

i_faddr for inode 127237 (...) is 4294967295, should be zero.
Clear? no

i_file_acl_hi for inode 127237 (...) is 65535, should be zero.
Clear? no

Extended attribute block for inode 127237 (...) is invalid (4294967295).
Clear? no

Unattached inode 127237
Connect to /lost+found? no

Inode 127238 (...) has invalid mode (0177777).
Clear? no

i_faddr for inode 127238 (...) is 4294967295, should be zero.
Clear? no

i_file_acl_hi for inode 127238 (...) is 65535, should be zero.
Clear? no

Extended attribute block for inode 127238 (...) is invalid (4294967295).
Clear? no

Unattached inode 127238
Connect to /lost+found? no

Inode 127239 (...) has invalid mode (0177777).
Clear? no

i_faddr for inode 127239 (...) is 4294967295, should be zero.
Clear? no

i_file_acl_hi for inode 127239 (...) is 65535, should be zero.
Clear? no

Extended attribute block for inode 127239 (...) is invalid (4294967295).
Clear? no

Unattached inode 127239
Connect to /lost+found? no

Inode 127240 (...) has invalid mode (0177777).
Clear? no

i_faddr for inode 127240 (...) is 4294967295, should be zero.
Clear? no

i_file_acl_hi for inode 127240 (...) is 65535, should be zero.
Clear? no

Extended attribute block for inode 127240 (...) is invalid (4294967295).
Clear? no

Unattached inode 127240
Connect to /lost+found? no

Inode 127241 (...) has invalid mode (0177777).
Clear? no

i_faddr for inode 127241 (...) is 4294967295, should be zero.
Clear? no

i_file_acl_hi for inode 127241 (...) is 65535, should be zero.
Clear? no

Extended attribute block for inode 127241 (...) is invalid (4294967295).
Clear? no

Unattached inode 127241
Connect to /lost+found? no

Inode 127242 (...) has invalid mode (0177777).
Clear? no

i_faddr for inode 127242 (...) is 4294967295, should be zero.
Clear? no

i_file_acl_hi for inode 127242 (...) is 65535, should be zero.
Clear? no

Extended attribute block for inode 127242 (...) is invalid (4294967295).
Clear? no

Unattached inode 127242
Connect to /lost+found? no

Inode 127243 (...) has invalid mode (0177777).
Clear? no

i_faddr for inode 127243 (...) is 4294967295, should be zero.
Clear? no

i_file_acl_hi for inode 127243 (...) is 65535, should be zero.
Clear? no

Extended attribute block for inode 127243 (...) is invalid (4294967295).
Clear? no

Unattached inode 127243
Connect to /lost+found? no

Inode 127244 (...) has invalid mode (0177777).
Clear? no

i_faddr for inode 127244 (...) is 4294967295, should be zero.
Clear? no

i_file_acl_hi for inode 127244 (...) is 65535, should be zero.
Clear? no

Extended attribute block for inode 127244 (...) is invalid (4294967295).
Clear? no

Unattached inode 127244
Connect to /lost+found? no

Inode 127245 (...) has invalid mode (0177777).
Clear? no

i_faddr for inode 127245 (...) is 4294967295, should be zero.
Clear? no

i_file_acl_hi for inode 127245 (...) is 65535, should be zero.
Clear? no

Extended attribute block for inode 127245 (...) is invalid (4294967295).
Clear? no

Unattached inode 127245
Connect to /lost+found? no

Inode 127246 (...) has invalid mode (0177777).
Clear? no

i_faddr for inode 127246 (...) is 4294967295, should be zero.
Clear? no

i_file_acl_hi for inode 127246 (...) is 65535, should be zero.
Clear? no

Extended attribute block for inode 127246 (...) is invalid (4294967295).
Clear? no

Unattached inode 127246
Connect to /lost+found? no

Inode 127247 (...) has invalid mode (0177777).
Clear? no

i_faddr for inode 127247 (...) is 4294967295, should be zero.
Clear? no

i_file_acl_hi for inode 127247 (...) is 65535, should be zero.
Clear? no

Extended attribute block for inode 127247 (...) is invalid (4294967295).
Clear? no

Unattached inode 127247
Connect to /lost+found? no

Inode 127248 (...) has invalid mode (0177777).
Clear? no

i_faddr for inode 127248 (...) is 4294967295, should be zero.
Clear? no

i_file_acl_hi for inode 127248 (...) is 65535, should be zero.
Clear? no

Extended attribute block for inode 127248 (...) is invalid (4294967295).
Clear? no

Unattached inode 127248
Connect to /lost+found? no

Unattached inode 127249
Connect to /lost+found? no

Unattached inode 127250
Connect to /lost+found? no

Unattached inode 127251
Connect to /lost+found? no

Unattached inode 127252
Connect to /lost+found? no

Unattached inode 127253
Connect to /lost+found? no

Unattached inode 127254
Connect to /lost+found? no

Unattached inode 127255
Connect to /lost+found? no

Unattached inode 127256
Connect to /lost+found? no

Unattached inode 127257
Connect to /lost+found? no

Unattached inode 127258
Connect to /lost+found? no

Unattached inode 127259
Connect to /lost+found? no

Unattached inode 127260
Connect to /lost+found? no

Unattached inode 127261
Connect to /lost+found? no

Unattached inode 127262
Connect to /lost+found? no

Unattached inode 127263
Connect to /lost+found? no

Unattached inode 127264
Connect to /lost+found? no

Unattached inode 127265
Connect to /lost+found? no

Unattached inode 127266
Connect to /lost+found? no

Unattached inode 127267
Connect to /lost+found? no

Unattached inode 127268
Connect to /lost+found? no

Unattached inode 127269
Connect to /lost+found? no

Unattached inode 127270
Connect to /lost+found? no

Unattached inode 127271
Connect to /lost+found? no

Unattached inode 127272
Connect to /lost+found? no

Unattached inode 127273
Connect to /lost+found? no

Unattached inode 127274
Connect to /lost+found? no

Unattached inode 127275
Connect to /lost+found? no

Unattached inode 127276
Connect to /lost+found? no

Unattached inode 127277
Connect to /lost+found? no

Unattached inode 127278
Connect to /lost+found? no

Unattached inode 127279
Connect to /lost+found? no

Unattached inode 127280
Connect to /lost+found? no

Unattached inode 127281
Connect to /lost+found? no

Unattached inode 127282
Connect to /lost+found? no

Unattached inode 127283
Connect to /lost+found? no

Unattached inode 127284
Connect to /lost+found? no

Unattached inode 127285
Connect to /lost+found? no

Unattached inode 127286
Connect to /lost+found? no

Unattached inode 127287
Connect to /lost+found? no

Unattached inode 127288
Connect to /lost+found? no

Unattached inode 127289
Connect to /lost+found? no

Unattached inode 127290
Connect to /lost+found? no

Unattached inode 127291
Connect to /lost+found? no

Unattached inode 127292
Connect to /lost+found? no

Unattached inode 127293
Connect to /lost+found? no

Unattached inode 127294
Connect to /lost+found? no

Unattached inode 127295
Connect to /lost+found? no

Unattached inode 127296
Connect to /lost+found? no

Unattached inode 127297
Connect to /lost+found? no

Unattached inode 127298
Connect to /lost+found? no

Unattached inode 127299
Connect to /lost+found? no

Unattached inode 127300
Connect to /lost+found? no

Unattached inode 127301
Connect to /lost+found? no

Unattached inode 127302
Connect to /lost+found? no

Unattached inode 127303
Connect to /lost+found? no

Unattached inode 127304
Connect to /lost+found? no

Unattached inode 127305
Connect to /lost+found? no

Unattached inode 127306
Connect to /lost+found? no

Unattached inode 127307
Connect to /lost+found? no

Unattached inode 127308
Connect to /lost+found? no

Unattached inode 127309
Connect to /lost+found? no

Unattached inode 127310
Connect to /lost+found? no

Unattached inode 127311
Connect to /lost+found? no

Unattached inode 127312
Connect to /lost+found? no

Unattached inode 127313
Connect to /lost+found? no

Unattached inode 127314
Connect to /lost+found? no

Unattached inode 127315
Connect to /lost+found? no

Unattached inode 127316
Connect to /lost+found? no

Unattached inode 127317
Connect to /lost+found? no

Unattached inode 127318
Connect to /lost+found? no

Unattached inode 127319
Connect to /lost+found? no

Unattached inode 127320
Connect to /lost+found? no

Unattached inode 127321
Connect to /lost+found? no

Unattached inode 127322
Connect to /lost+found? no

Unattached inode 127323
Connect to /lost+found? no

Unattached inode 127324
Connect to /lost+found? no

Unattached inode 127325
Connect to /lost+found? no

Unattached inode 127326
Connect to /lost+found? no

Unattached inode 127327
Connect to /lost+found? no

Unattached inode 127328
Connect to /lost+found? no

Unattached inode 127329
Connect to /lost+found? no

Unattached inode 127330
Connect to /lost+found? no

Unattached inode 127331
Connect to /lost+found? no

Unattached inode 127332
Connect to /lost+found? no

Unattached inode 127333
Connect to /lost+found? no

Unattached inode 127334
Connect to /lost+found? no

Unattached inode 127335
Connect to /lost+found? no

Unattached inode 127336
Connect to /lost+found? no

Unattached inode 127337
Connect to /lost+found? no

Unattached inode 127338
Connect to /lost+found? no

Unattached inode 127339
Connect to /lost+found? no

Unattached inode 127340
Connect to /lost+found? no

Unattached inode 127341
Connect to /lost+found? no

Unattached inode 127342
Connect to /lost+found? no

Unattached inode 127343
Connect to /lost+found? no

Unattached inode 127344
Connect to /lost+found? no

Unattached inode 127345
Connect to /lost+found? no

Unattached inode 127346
Connect to /lost+found? no

Unattached inode 127347
Connect to /lost+found? no

Unattached inode 127348
Connect to /lost+found? no

Unattached inode 127349
Connect to /lost+found? no

Unattached inode 127350
Connect to /lost+found? no

Unattached inode 127351
Connect to /lost+found? no

Unattached inode 127352
Connect to /lost+found? no

Unattached inode 127353
Connect to /lost+found? no

Unattached inode 127354
Connect to /lost+found? no

Unattached inode 127355
Connect to /lost+found? no

Unattached inode 127356
Connect to /lost+found? no

Unattached inode 127357
Connect to /lost+found? no

Unattached inode 127358
Connect to /lost+found? no

Unattached inode 127359
Connect to /lost+found? no

Unattached inode 127360
Connect to /lost+found? no

Unattached inode 127361
Connect to /lost+found? no

Unattached inode 127362
Connect to /lost+found? no

Unattached inode 127363
Connect to /lost+found? no

Unattached inode 127364
Connect to /lost+found? no

Unattached inode 127365
Connect to /lost+found? no

Unattached inode 127366
Connect to /lost+found? no

Unattached inode 127367
Connect to /lost+found? no

Unattached inode 127368
Connect to /lost+found? no

Unattached inode 127369
Connect to /lost+found? no

Unattached inode 127370
Connect to /lost+found? no

Unattached inode 127371
Connect to /lost+found? no

Unattached inode 127372
Connect to /lost+found? no

Unattached inode 127373
Connect to /lost+found? no

Unattached inode 127374
Connect to /lost+found? no

Unattached inode 127375
Connect to /lost+found? no

Unattached inode 127376
Connect to /lost+found? no

Unattached inode 127377
Connect to /lost+found? no

Unattached inode 127378
Connect to /lost+found? no

Unattached inode 127379
Connect to /lost+found? no

Unattached inode 127380
Connect to /lost+found? no

Unattached inode 127381
Connect to /lost+found? no

Unattached inode 127382
Connect to /lost+found? no

Unattached inode 127383
Connect to /lost+found? no

Unattached inode 127384
Connect to /lost+found? no

Unattached inode 127385
Connect to /lost+found? no

Unattached inode 127386
Connect to /lost+found? no

Unattached inode 127387
Connect to /lost+found? no

Unattached inode 127388
Connect to /lost+found? no

Unattached inode 127389
Connect to /lost+found? no

Unattached inode 127390
Connect to /lost+found? no

Unattached inode 127391
Connect to /lost+found? no

Unattached inode 127392
Connect to /lost+found? no

Unattached inode 127393
Connect to /lost+found? no

Unattached inode 127394
Connect to /lost+found? no

Unattached inode 127395
Connect to /lost+found? no

Unattached inode 127396
Connect to /lost+found? no

Unattached inode 127397
Connect to /lost+found? no

Unattached inode 127398
Connect to /lost+found? no

Unattached inode 127399
Connect to /lost+found? no

Unattached inode 127400
Connect to /lost+found? no

Unattached inode 127401
Connect to /lost+found? no

Unattached inode 127402
Connect to /lost+found? no

Unattached inode 127403
Connect to /lost+found? no

Unattached inode 127404
Connect to /lost+found? no

Unattached inode 127405
Connect to /lost+found? no

Unattached inode 127406
Connect to /lost+found? no

Unattached inode 127407
Connect to /lost+found? no

Unattached inode 127408
Connect to /lost+found? no

Unattached inode 127409
Connect to /lost+found? no

Unattached inode 127410
Connect to /lost+found? no

Unattached inode 167506
Connect to /lost+found? no

Pass 5: Checking group summary information
Block bitmap differences:  -524301 -524317 -(557056--557761)
Fix? no

Directories count wrong for group #16 (762, counted=760).
Fix? no


/dev/mapper/loop1p2: ********** WARNING: Filesystem still has errors **********

/dev/mapper/loop1p2: 102125/230608 files (0.2% non-contiguous), 622979/921600 blocks

---------------------------------------------------------------
---------------------------------------------------------------
---------------------------------------------------------------
and now dumpe2fs
dumpe2fs 1.42 (29-Nov-2011)
Filesystem volume name:   <none>
Last mounted on:          /root/dom/a
Filesystem UUID:          6ee8fc7f-9229-44c2-8173-921b9d625436
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    user_xattr acl
Filesystem state:         clean with errors
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              230608
Block count:              921600
Reserved block count:     9216
Free blocks:              298621
Free inodes:              128483
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      224
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         7952
Inode blocks per group:   497
Flex block group size:    16
Filesystem created:       Wed May 15 12:44:06 2013
Last mount time:          Tue Jan 28 17:45:16 2014
Last write time:          Tue Jan 28 17:58:34 2014
Mount count:              37
Maximum mount count:      -1
Last checked:             Fri Dec 13 16:56:50 2013
Check interval:           15552000 (6 months)
Next check after:         Wed Jun 11 17:56:50 2014
Lifetime writes:          2692 MB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      43472f4b-ba7f-4204-97d8-9addd838f9a6
Journal backup:           inode blocks
FS Error count:           13
First error time:         Wed Jan 15 08:46:12 2014
First error function:     ext4_iget
First error line #:       3888
First error inode #:      127233
First error block #:      0
Last error time:          Tue Jan 28 17:46:07 2014
Last error function:      ext4_iget
Last error line #:        3888
Last error inode #:       127233
Last error block #:       0
Journal features:         journal_incompat_revoke
Journal size:             64M
Journal length:           16384
Journal sequence:         0x000120e7
Journal start:            0


Group 0: (Blocks 0-32767) [ITABLE_ZEROED]
  Checksum 0x2793, unused inodes 0
  Primary superblock at 0, Group descriptors at 1-1
  Reserved GDT blocks at 2-225
  Block bitmap at 226 (+226), Inode bitmap at 242 (+242)
  Inode table at 258-754 (+258)
  17418 free blocks, 0 free inodes, 1013 directories
  Free blocks: 9696-9703, 9712-9715, 15345-15366, 15380-15387, 15392-32767
  Free inodes: 
Group 1: (Blocks 32768-65535) [ITABLE_ZEROED]
  Checksum 0xb365, unused inodes 0
  Backup superblock at 32768, Group descriptors at 32769-32769
  Reserved GDT blocks at 32770-32993
  Block bitmap at 227 (bg #0 + 227), Inode bitmap at 243 (bg #0 + 243)
  Inode table at 755-1251 (bg #0 + 755)
  1 free blocks, 0 free inodes, 741 directories
  Free blocks: 51268
  Free inodes: 
Group 2: (Blocks 65536-98303) [ITABLE_ZEROED]
  Checksum 0xed5f, unused inodes 0
  Block bitmap at 228 (bg #0 + 228), Inode bitmap at 244 (bg #0 + 244)
  Inode table at 1252-1748 (bg #0 + 1252)
  114 free blocks, 0 free inodes, 1175 directories
  Free blocks: 97098-97099, 97120-97131, 97136-97139, 97144-97151, 97312-97319, 98040-98047, 98080-98083, 98188-98191, 98240-98303
  Free inodes: 
Group 3: (Blocks 98304-131071) [ITABLE_ZEROED]
  Checksum 0x3127, unused inodes 0
  Backup superblock at 98304, Group descriptors at 98305-98305
  Reserved GDT blocks at 98306-98529
  Block bitmap at 229 (bg #0 + 229), Inode bitmap at 245 (bg #0 + 245)
  Inode table at 1749-2245 (bg #0 + 1749)
  10815 free blocks, 0 free inodes, 868 directories
  Free blocks: 99320-99327, 99348-99391, 99408-99415, 99420-99421, 99424-99471, 99488-99496, 99498-99499, 99501-99552, 99554-99567, 99675-99724, 99769-99775, 99813-99839, 99917-99929, 100096-100121, 100161-100165, 100203-100215, 100333-100335, 100341-100351, 101274-101284, 101311-101312, 101340, 101372-101375, 101672-101673, 101675-101695, 101752-101759, 101797-101823, 101861-101887, 101962-101973, 102015-102064, 102094-102095, 102188-102260, 102393-102399, 102437-102463, 102501-102521, 102905-102925, 102927-103103, 103141-103167, 103422-103423, 106390-106431, 106469-106495, 106533-106618, 106631-106687, 106725-106751, 106789-106815, 106853-106879, 106917-106943, 106981-107009, 107011-107263, 107485-107548, 107551-107775, 108030-108149, 108153-108154, 108158-108160, 108167-108543, 108602-108603, 108608-108611, 109831-109837, 109862-109863, 109865-109867, 109872-109874, 109928-109935, 110089-110233, 110236-110238, 110248-110439, 112666-112691, 112710, 112712-112719, 112964-112975, 113048-113149, 113664-113757, 113760-114636, 114725-114751, 114789-114815, 114853-114879, 114917-114943, 114981-115007, 115045-115071, 115109-115135, 115173-115199, 115237-115263, 115301-115327, 115365-115391, 115429-115711, 115749-115775, 115813-115839, 115877-115903, 115941-115967, 116005-116031, 116069-116095, 116133-116159, 116197-116223, 116261-116287, 116325-116351, 116389-116415, 116453-116479, 116517-116543, 116581-116607, 116645-116748, 116750-117273, 117282-117777, 117780-118287, 118289-118793, 118796-118843, 118916-119300, 119302-119304, 119308-119327, 119329-119810, 119812-119813, 119815-120324, 120327-120328, 120330-120843, 120845-121359, 121361-121859, 121861-121978, 121981-122368, 122370-122381, 122397-122414, 122418-122433, 122438-122879
  Free inodes: 
Group 4: (Blocks 131072-163839) [ITABLE_ZEROED]
  Checksum 0xfd99, unused inodes 0
  Block bitmap at 230 (bg #0 + 230), Inode bitmap at 246 (bg #0 + 246)
  Inode table at 2246-2742 (bg #0 + 2246)
  0 free blocks, 0 free inodes, 861 directories
  Free blocks: 
  Free inodes: 
Group 5: (Blocks 163840-196607) [ITABLE_ZEROED]
  Checksum 0x1b9e, unused inodes 0
  Backup superblock at 163840, Group descriptors at 163841-163841
  Reserved GDT blocks at 163842-164065
  Block bitmap at 231 (bg #0 + 231), Inode bitmap at 247 (bg #0 + 247)
  Inode table at 2743-3239 (bg #0 + 2743)
  0 free blocks, 1 free inodes, 741 directories
  Free blocks: 
  Free inodes: 44110
Group 6: (Blocks 196608-229375) [ITABLE_ZEROED]
  Checksum 0x0b53, unused inodes 0
  Block bitmap at 232 (bg #0 + 232), Inode bitmap at 248 (bg #0 + 248)
  Inode table at 3240-3736 (bg #0 + 3240)
  0 free blocks, 364 free inodes, 487 directories
  Free blocks: 
  Free inodes: 48225, 48245, 48255, 48283-48284, 48286-48287, 48367-48393, 48395-48399, 48406, 48415-48427, 48429-48431, 48434, 48437, 48455-48457, 48459-48637, 49081, 49097, 49102, 49759, 50777, 51071, 51329, 51647, 52567, 53168, 53422, 53474, 53731, 53735, 53746, 53749, 53760, 53768, 53774, 53779, 53786, 53792, 53798, 53802, 53809, 53815, 53821, 53826, 53832, 53838, 53846, 53853, 53860, 53862, 53869, 53877, 53881, 53886, 53893, 53897, 53901, 53909, 53915, 53934-53935, 53939, 53943-53944, 53986, 53991, 53993-53995, 53997-53998, 54000, 54009-54010, 54012-54014, 54018, 54051, 54100, 54108, 54119-54120, 54122, 54124, 54127-54128, 54130-54132, 54135-54177, 54180-54181, 54192, 54200, 54202-54203, 54209
Group 7: (Blocks 229376-262143) [ITABLE_ZEROED]
  Checksum 0x8ffb, unused inodes 3874
  Backup superblock at 229376, Group descriptors at 229377-229377
  Reserved GDT blocks at 229378-229601
  Block bitmap at 233 (bg #0 + 233), Inode bitmap at 249 (bg #0 + 249)
  Inode table at 3737-4233 (bg #0 + 3737)
  78 free blocks, 3977 free inodes, 348 directories, 3874 unused inodes
  Free blocks: 255380-255457
  Free inodes: 56106, 56113, 56720, 56724, 56727, 56732, 56735-56736, 56741, 56744-56745, 56750, 56754-56755, 56760, 56763-56764, 56766-56768, 56813-56814, 56816, 56827, 56830-56831, 56833, 56851-56852, 56856, 56920-56921, 56926, 56990-56991, 56995, 57022-57023, 57027, 57142-57143, 57147, 57251-57254, 57258, 57358-57359, 57363, 57577-57578, 57582, 57623-57624, 57628, 57750-57751, 57756, 57766, 57851-57852, 57856, 57862-57863, 57865, 57871-57872, 57876, 57893-57894, 57896, 57904-57905, 57908, 57911-57912, 57914, 57927-57928, 57930, 58303-58304, 58306, 58323-58324, 58326, 58331-58332, 58334, 58522-58527, 58539, 59065, 59208, 59693, 59740-63616
Group 8: (Blocks 262144-294911) [ITABLE_ZEROED]
  Checksum 0x0c36, unused inodes 7695
  Block bitmap at 234 (bg #0 + 234), Inode bitmap at 250 (bg #0 + 250)
  Inode table at 4234-4730 (bg #0 + 4234)
  0 free blocks, 7922 free inodes, 30 directories, 7695 unused inodes
  Free blocks: 
  Free inodes: 63647-71568
Group 9: (Blocks 294912-327679) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xefe1, unused inodes 7952
  Backup superblock at 294912, Group descriptors at 294913-294913
  Reserved GDT blocks at 294914-295137
  Block bitmap at 235 (bg #0 + 235), Inode bitmap at 251 (bg #0 + 251)
  Inode table at 4731-5227 (bg #0 + 4731)
  0 free blocks, 7952 free inodes, 0 directories, 7952 unused inodes
  Free blocks: 
  Free inodes: 71569-79520
Group 10: (Blocks 327680-360447) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x58db, unused inodes 7952
  Block bitmap at 236 (bg #0 + 236), Inode bitmap at 252 (bg #0 + 252)
  Inode table at 5228-5724 (bg #0 + 5228)
  3259 free blocks, 7952 free inodes, 0 directories, 7952 unused inodes
  Free blocks: 333568-333759, 333766-333775, 333786-333788, 335961, 336052, 336675, 336677, 336704-336707, 336775-336776, 336832-336833, 340046-340063, 340070-340071, 340814-340815, 341168-341183, 341190-341191, 341966-341967, 341972-341975, 341984-342041, 342044-343031, 343034-343126, 343177-343572, 343574-344063, 348160-348407, 348872-348889, 349247, 351646, 352256-352259, 352261-352935, 355819, 355825, 356121, 356124-356135, 356139-356147
  Free inodes: 79521-87472
Group 11: (Blocks 360448-393215) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x3373, unused inodes 7952
  Block bitmap at 237 (bg #0 + 237), Inode bitmap at 253 (bg #0 + 253)
  Inode table at 5725-6221 (bg #0 + 5725)
  24703 free blocks, 7952 free inodes, 0 directories, 7952 unused inodes
  Free blocks: 360448-360474, 360476-360485, 360534-360557, 361154, 361733, 363155, 364090-364143, 364511, 364948-365195, 365205-365442, 365669-365681, 365688-365697, 365700-365718, 365720-365723, 365728-365740, 365744-365766, 365768-365772, 365776-366028, 366032-366043, 366048-366066, 366068-366071, 366111-366112, 366123-366133, 366669-366671, 366804-367210, 367212-367223, 367463-367540, 367615, 367617-367819, 367839-367850, 367999, 368074-368092, 368121-368127, 368145, 368158, 368174, 368179, 368203, 368216, 368232, 368245, 368267, 368280, 368296, 368309, 368327, 368340, 368353, 368366, 368377-368577, 368615-368643, 368659-368737, 369001-369151, 369159-369510, 369659-369663, 369665-369668, 369670, 370177-370193, 370689-370698, 370736-370743, 370745, 370751-371199, 371201-371714, 371716-371830, 371832-372313, 372317-372750, 372752-372755, 372758-373250, 373252-373272, 373274-373759, 373761-374394, 374417-374812, 374814-375298, 375300-375316, 375318-375812, 375825-376327, 376329-376330, 376341-376343, 376345-376832, 376834-377351, 377355, 377357-377860, 377862-377986, 377988-378373, 378375-378887, 378890-378891, 378894, 378904-379410, 379412-379923, 379936-380415, 380417-380928, 380930-380937, 380939-380957, 380970, 380979-380988, 380990-381444, 381554-381568, 381583-381586, 381588, 381618-381951, 381958-382484, 382487-382975, 382977-383494, 383505-383510, 383512-384008, 384024-384532, 384536-385038, 385040-385097, 385099-385537, 385540-385542, 385560-386061, 386063-386570, 386572-387082, 387084-387650, 387652-388835, 388837-389120, 389122-389123, 389131-389631, 389633-389634, 389644-389648, 389657-389698, 389700-389708, 389711-391167, 391172, 391174, 391176-391689, 391691-393215
  Free inodes: 87473-95424
Group 12: (Blocks 393216-425983) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xfb7a, unused inodes 7952
  Block bitmap at 238 (bg #0 + 238), Inode bitmap at 254 (bg #0 + 254)
  Inode table at 6222-6718 (bg #0 + 6222)
  15305 free blocks, 7952 free inodes, 0 directories, 7952 unused inodes
  Free blocks: 394494-394668, 394860-409599, 409843-409847, 409856-409990, 410211-410365, 410550-410629, 410633, 410638, 411136-411140, 411143-411144, 411148, 411155-411156, 411164, 411175, 411647
  Free inodes: 95425-103376
Group 13: (Blocks 425984-458751) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x2b8a, unused inodes 7952
  Block bitmap at 239 (bg #0 + 239), Inode bitmap at 255 (bg #0 + 255)
  Inode table at 6719-7215 (bg #0 + 6719)
  0 free blocks, 7952 free inodes, 0 directories, 7952 unused inodes
  Free blocks: 
  Free inodes: 103377-111328
Group 14: (Blocks 458752-491519) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xfe1d, unused inodes 7952
  Block bitmap at 240 (bg #0 + 240), Inode bitmap at 256 (bg #0 + 256)
  Inode table at 7216-7712 (bg #0 + 7216)
  19607 free blocks, 7952 free inodes, 0 directories, 7952 unused inodes
  Free blocks: 469739-469980, 472155-491519
  Free inodes: 111329-119280
Group 15: (Blocks 491520-524287) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x556e, unused inodes 7952
  Block bitmap at 241 (bg #0 + 241), Inode bitmap at 257 (bg #0 + 257)
  Inode table at 7713-8209 (bg #0 + 7713)
  21398 free blocks, 7952 free inodes, 0 directories, 7952 unused inodes
  Free blocks: 491520-498687, 499292-499295, 499317-499327, 499371-499391, 499415-499423, 499449-499455, 499553-499583, 499632-499647, 499701-511455, 511478-511487, 511526-511551, 511587-511615, 511667-511679, 511704-511711, 511732-511743, 511947-511967, 511999-512223, 512246-512255, 512319, 512373-512383, 512479, 512507-512511, 512759-512767, 512883-512895, 512916-512927, 512958-512959, 513013-513023, 513074-513087, 513122-513151, 513172-513183, 513204-513215, 513259-513279, 513338-513343, 513363-513375, 513402-513407, 513471, 513515-513535, 514068-514079, 514105-514111, 514152-514175, 514254-514271, 514323-514335, 514359-514367, 514404-514431, 514478-514495, 514522-514527, 514552-514559, 515268-515295, 515320-515327, 515389-515391, 515440-515455, 515496-515519, 515537-515551, 515578-515583, 515772-515775, 515828-515839, 515873-515903, 515923-515935, 515957-515967, 515992-515999, 516029-516031, 516068-516095, 516116-516127, 516154-516159, 516190-516191, 516214-516223, 516283-516287, 516322-516351, 516489-516511, 516539-516543, 516588-516607, 516686-516703, 516722-516735, 516834-516863, 516926-516927, 516983-516991, 517116-517119, 517155-517183, 517232-517247, 517313-517343, 517372-517375, 517441-517471, 517496-517503, 517540-517567, 517607-517631, 517666-517695, 517742-517759, 517832-517855, 517875-517887, 517908-517919, 517938-517951, 517989-518015, 518058-518079, 518116-518143, 519220-519231, 519249-519263, 519295, 519355-519359, 519379-519391, 519629-519647, 519672-519679, 519763-519775, 519794-519807, 519864-519871, 519914-519935, 519960-519967, 519994-519999, 520017-520031, 520054-520063, 520085-520095, 520114-520127, 520155-520159, 520190-520191, 520252-520255, 520304-520319, 520345-520351, 520372-520383, 520419-520447, 520467-520479, 520505-520511, 520533-520543, 520561-520575, 520603-520607, 520638-520639, 520692-520703, 521290-521311, 521330-521343, 521416-521439, 521459-521471, 521489-521503, 521521-521535, 521580-521599, 521674-521695, 521713-521727, 521774-521791, 521810-521823, 521844-521855, 521901-521919, 521954-521983, 522050-522079, 522102-522111, 522169-522175, 522226-522239, 522381-522399, 522422-522431, 522481-522495, 522604-522623, 522641-522655, 522675-522687, 522722-522751, 522772-522783, 522802-522815, 522866-522879, 522899-522911, 522936-522943, 522984-523007, 523100-523135, 523237-523263
  Free inodes: 119281-127232
Group 16: (Blocks 524288-557055) [ITABLE_ZEROED]
  Checksum 0x7cef, unused inodes 0
  Block bitmap at 524288 (+0), Inode bitmap at 524304 (+16)
  Inode table at 524320-524816 (+32)
  20533 free blocks, 996 free inodes, 762 directories
  Free blocks: 531147-531162, 536539-557055
  Free inodes: 130936, 131079-131084, 131086-131088, 131090-131098, 131100-131101, 131103-131105, 131107-131112, 131114-131120, 131123-131134, 131136-131144, 131146-131156, 131158-131160, 131162-131165, 131167-131173, 131176-131179, 131181, 131183-131197, 131199-131202, 131204-131209, 131211-131213, 131215-131227, 131229-131230, 131232-131234, 131236-131243, 131245-131250, 131253-131264, 131266-131270, 131272-131273, 131275-131285, 131287-131290, 131292-131303, 131305-131306, 131309-131314, 131316, 131318-131319, 131321-131335, 131337-131344, 131346-131352, 131354-131356, 131358-131371, 131373-131380, 131382-131384, 131386-131392, 131394-131399, 131401, 131403-131411, 131413, 131415-131417, 131419, 131421-131432, 131434-131441, 131443-131453, 131455-131457, 131459-131474, 131476-131527, 131529-131534, 131536-131540, 131542-131564, 131566-131575, 131577-131589, 131591-131598, 131600-131603, 131605-131611, 131613, 131615-131623, 131625, 131627-131629, 131631, 131633-131644, 131646-131657, 131659-131669, 131671-131673, 131675-131690, 131692-131743, 131745-131750, 131752-131756, 131758-131781, 131783-131796, 131798-131810, 131812-131819, 131821-131824, 131826-131832, 131835-131838, 131840, 131842, 131844-131855, 131857-131864, 131866-131876, 131878-131880, 131882-131910, 131912-131915, 131917-131920, 131922-131926, 131928-131940, 131942-131948, 131950, 131952-131960, 131962, 131964-131966, 131968, 131970-131981, 131983-131990, 131992-132002, 132004-132006, 132008-132023, 132025-132076, 132078-132083, 132085-132089, 132091-132113, 132115-132124, 132126-132138, 132140-132147, 132149-132152, 132154-132185, 132207, 132210-132211, 132214-132215
Group 17: (Blocks 557056-589823) [ITABLE_ZEROED]
  Checksum 0xda0d, unused inodes 0
  Block bitmap at 524289 (bg #16 + 1), Inode bitmap at 524305 (bg #16 + 17)
  Inode table at 524817-525313 (bg #16 + 529)
  2746 free blocks, 0 free inodes, 1828 directories
  Free blocks: 577408-577535, 577888-577951, 577977-577978, 578047, 578152-578167, 578440-578444, 578447-578559, 579072-579175, 579184-579231, 579557-581613, 581616-581717, 581740-581813, 581824-581855
  Free inodes: 
Group 18: (Blocks 589824-622591) [ITABLE_ZEROED]
  Checksum 0xf843, unused inodes 0
  Block bitmap at 524290 (bg #16 + 2), Inode bitmap at 524306 (bg #16 + 18)
  Inode table at 525314-525810 (bg #16 + 1026)
  1 free blocks, 0 free inodes, 537 directories
  Free blocks: 593965
  Free inodes: 
Group 19: (Blocks 622592-655359) [ITABLE_ZEROED]
  Checksum 0xbbbf, unused inodes 0
  Block bitmap at 524291 (bg #16 + 3), Inode bitmap at 524307 (bg #16 + 19)
  Inode table at 525811-526307 (bg #16 + 1523)
  0 free blocks, 0 free inodes, 626 directories
  Free blocks: 
  Free inodes: 
Group 20: (Blocks 655360-688127) [ITABLE_ZEROED]
  Checksum 0xed82, unused inodes 0
  Block bitmap at 524292 (bg #16 + 4), Inode bitmap at 524308 (bg #16 + 20)
  Inode table at 526308-526804 (bg #16 + 2020)
  1737 free blocks, 0 free inodes, 1188 directories
  Free blocks: 674108-674111, 674155-674175, 674225-674239, 674257-674271, 674290-674303, 675350-675359, 675377-675391, 675412-675423, 675453-675455, 675486-675487, 675514-675519, 675537-675551, 675574-675583, 675601-675615, 675634-675647, 675689-675711, 675745-675775, 675829-675839, 675863-675871, 675894-675903, 675966-675967, 676034-676063, 676087-676095, 676116-676127, 676152-676159, 676183-676191, 676210-676223, 676274-676287, 676344-676351, 677455-677471, 677489-677503, 677601-677631, 677701-677727, 677745-677759, 677793-677823, 677880-677887, 677945-677951, 678002-678015, 678050-678079, 678099-678111, 678143, 678185-678207, 678225-678239, 678258-678271, 678305-678335, 678363-678367, 678389-678399, 679036-679039, 679087-679103, 679144-679167, 679283-679295, 679342-679359, 679402-679423, 680042-680063, 680148-680159, 680190-680191, 680247-680255, 680281-680287, 680313-680319, 680345-680351, 680369-680383, 680409-680415, 680443-680447, 681508-681535, 681555-681567, 681595-681599, 681681-681695, 681718-681727, 681795-681823, 681843-681855, 681925-681951, 681980-681983, 682055-682079, 682102-682111, 682213-682239, 682441-682463, 682481-682495, 682530-682559, 682603-682623, 682657-682687, 682705-682719, 682748-682751, 682867-682879, 682962-682975, 683002-683007, 684940-684959, 684977-684991, 685010-685023, 685043-685055, 685437-685439, 685457-685471, 685501-685503, 685540-685567, 685623-685631, 685655-685663, 685691-685695, 685715-685727, 685752-685759, 685808-685823, 685862-685887, 685927-685951, 686020-686079, 686337-686367, 686390-686399, 686423-686431, 686452-686463, 686532-686559, 686582-686591, 687361-687391, 687416-687423, 687441-687455, 687473-687487, 687535-687551, 687585-687615
  Free inodes: 
Group 21: (Blocks 688128-720895) [ITABLE_ZEROED]
  Checksum 0xb072, unused inodes 3896
  Block bitmap at 524293 (bg #16 + 5), Inode bitmap at 524309 (bg #16 + 21)
  Inode table at 526805-527301 (bg #16 + 2517)
  4641 free blocks, 3897 free inodes, 409 directories, 3896 unused inodes
  Free blocks: 688169-688191, 688217-688223, 688255, 688278-688287, 688306-688319, 688346-688351, 688377-688383, 688575, 688599-688607, 688635-688639, 689196-689215, 689240-689247, 689274-689279, 689374-689375, 689393-689407, 689619-689631, 689662-689663, 689704-689727, 689785-689791, 689859-689887, 689914-689919, 689955-689983, 690005-690015, 690041-690047, 690101-690111, 690154-690175, 690209-690239, 690259-690271, 690294-690303, 690322-690335, 690357-690367, 690385-690399, 690425-690431, 690454-690463, 690485-690495, 690526-690527, 690554-690559, 690581-690591, 690610-690623, 690662-690687, 691752-691775, 691794-691807, 691827-691839, 691954-691967, 692030-692031, 692050-692063, 692089-692095, 692137-692159, 692177-692191, 692214-692223, 693188, 693190, 693192-693193, 693196, 693198, 693200-693201, 693204, 693206, 693208-693209, 693212, 693214, 693216-693220, 693271-693279, 693299-693311, 693334-693343, 693361-693375, 693393-693407, 693426-693439, 693459-693471, 693490-693503, 693527-693535, 693564-693567, 693588-693599, 693619-693631, 693652-693663, 693687-693695, 693714-693727, 693747-693759, 694423-694424, 694801-694815, 694839-694847, 694873-694879, 694899-694911, 695026-695039, 695108-695135, 695164-695167, 695265-695295, 695609-695615, 695651-695679, 695803-695807, 695859-695871, 695921-695935, 695984-695999, 696039-696063, 696140-696159, 696183-696191, 696241-696255, 696303-696319, 696766-696767, 696802-696831, 696935-696959, 697087, 697274-697279, 697319-697343, 697673-697695, 697724-697727, 697751-697759, 697789-697791, 697827-697855, 697896-697919, 697938-697951, 697977-697983, 698067-698079, 698097-698111, 698222-698239, 698308-698335, 698362-698367, 698488-698495, 698546-698559, 698596-698623, 698798-698815, 698834-698847, 698870-698879, 698905-698911, 698934-698943, 698971-698975, 699005-699007, 699091-699103, 699134-699135, 699204-699231, 699254-699263, 699298-699327, 699349-699359, 699379-699391, 699921-699935, 699953-699967, 700009-700031, 700130-700159, 700347-700351, 700369-700383, 700412-700415, 700433-700447, 700467-700479, 700515-700543, 700565-700575, 700597-700607, 700628-700639, 700660-700671, 700695-700703, 700722-700735, 700756-700767, 700790-700799, 700819-700831, 700862-700863, 700884-700895, 700913-700927, 701675-701695, 701927-701951, 701971-701983, 702002-702015, 702075-702079, 702122-702143, 702175, 702202-702207, 702238-702239, 702259-702271, 702333-702335, 702354-702367, 702386-702399, 702422-702431, 702450-702463, 702487-702495, 702526-702527, 702554-702559, 702577-702591, 702635-702655, 702677-702687, 702707-702719, 702737-702751, 702775-702783, 702814-702815, 702837-702847, 702876-702879, 702899-702911, 702968-702975, 703028, 703063, 703528-703551, 703608-703615, 703633-703647, 703665-703679, 703728-703743, 703807, 703842-703871, 703891-703903, 703922-703935, 703972-703999, 704622-704639, 704765-704767, 704880-704895, 704922-704927, 704945-704959, 704982-704991, 705017-705023, 705085-705087, 705119, 705150-705151, 705172-705183, 705202-705215, 705254-705279, 705314-705343, 705363-705375, 705400-705407, 705470-705471, 705503, 705530-705535, 705626-705631, 705655-705663, 705788-705791, 705947-705951, 705982-705983, 706030-706047, 706207, 706233-706239, 706303, 706512-706527, 706553-706559, 706648-706655, 706681-706687, 706775-706783, 706802-706815, 706902-706911, 706931-706943, 707036-707039, 707057-707071, 707174-707199, 707290-707295, 707317-707327, 707413-707423, 707449-707455, 707498-707519, 707560-707583, 708035-708063, 708084-708095, 708171-708191, 708209-708223, 708262-708287, 708322-708351, 708577-708607, 709387-709407, 709427-709439, 709488-709503, 709579-709599, 709618-709631, 710958-710975, 711021-711039, 711150-711167, 711247-711263, 711289-711295, 711366-711391, 711409-711423, 711523-711551, 711628-711647, 711667-711679, 711708-711711, 711765-711768, 711770-711771, 711774, 711776, 711778-711779, 711782, 711784, 711852-711853, 711855, 711857, 711859-711860, 711863, 711865, 711868-711869, 711872, 711874, 711877-711878, 711880, 711882, 711885-711886, 711892, 711894, 711900-711901, 711903, 711905, 711907-711908, 711911, 711913, 711916-711917, 711920, 711923, 711956-711957, 711959, 711961, 711963-711966, 711968-711969, 711971, 711973, 711975-711978, 711994-711996, 711998, 712000-712003, 712029-712032, 712781-712799, 712822-712831, 712911-712927, 712945-713215, 714031-714047, 714075-714079, 714106-714111, 714217-714239, 715211, 715825-715839, 715899-715903, 715984-715999, 716023-716287, 716843-716927, 717008-717023, 717045-717311, 718185-718207, 718293-718335, 719210-719359, 719458-719461, 719494-719497, 719514-719517, 719582-719587, 719605, 719607-719612
  Free inodes: 167504, 171049-174944
Group 22: (Blocks 720896-753663) [ITABLE_ZEROED]
  Checksum 0xfb30, unused inodes 7950
  Block bitmap at 524294 (bg #16 + 6), Inode bitmap at 524310 (bg #16 + 22)
  Inode table at 527302-527798 (bg #16 + 3014)
  6752 free blocks, 7950 free inodes, 2 directories, 7950 unused inodes
  Free blocks: 721197-721215, 721255-721279, 721311, 721329-721343, 721379-721407, 721619-721631, 721653-721663, 721825-721855, 721904-721919, 722023-722047, 722072-722079, 722108-722111, 722172-722175, 722253-722271, 722295-722303, 722383-722399, 722430-722431, 723119-723135, 723156-723167, 723199, 723222-723231, 723254-723263, 723298-723327, 723441-723455, 723826-723839, 723864-723871, 723896-723903, 723938-723967, 724107-724127, 724159, 724195-724223, 724363-724383, 724407-724415, 724447, 724475-724479, 724614-724639, 724657-724671, 724720-724735, 724882-724895, 724923-724927, 724945-724959, 724979-724991, 725654, 726537, 726554-726562, 727086-727103, 727150-727167, 727236-727263, 727281-727295, 727500-727519, 727550-727551, 727598-727615, 727670-727679, 727704-727711, 727733-727743, 727768-727775, 728016-728031, 728049-728063, 729326-729343, 729366-729375, 729402-729407, 729425-729439, 729460-729471, 729511-729535, 729557-729567, 729588-729599, 729732-729759, 729783-729791, 729832-729855, 730070-730079, 730104-730111, 730977-731007, 731066-731071, 731108-731135, 731253-731269, 731282-731291, 731419-731467, 731469-731490, 731492-731499, 731506-731510, 731512-731519, 732529-732543, 732598-732607, 732659-732671, 732789-732799, 732893-732895, 732917-732927, 733076-733087, 733116-733119, 733159-733183, 733337-733343, 733364-733439, 733663, 733689-733695, 733774-733855, 734084-734086, 734095-734120, 734122-734123, 734127-734136, 734146, 734150-734207, 734613-734623, 734648-734719, 734928-734975, 735051-735231, 738011-738015, 738048-738271, 738294-738815, 743353-743423, 743443-747519
  Free inodes: 174947-182896
Group 23: (Blocks 753664-786431) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x8e2e, unused inodes 7952
  Block bitmap at 524295 (bg #16 + 7), Inode bitmap at 524311 (bg #16 + 23)
  Inode table at 527799-528295 (bg #16 + 3511)
  14797 free blocks, 7952 free inodes, 0 directories, 7952 unused inodes
  Free blocks: 756145, 756158-756159, 756174-756175, 756355-756364, 756396-756399, 756462-756463, 756554-756559, 757145-757151, 757594-757599, 757633-757652, 757665-757679, 757696-757698, 757709-757718, 757743-757759, 760594-760607, 760664-760671, 760686-760687, 760702-760703, 760710-760719, 760762-760767, 760874-760895, 760956-760959, 761079-761087, 761194-761215, 761253-761279, 761381-761471, 761476-761791, 761829-761855, 767685-767695, 767781-767807, 767909-767935, 768061-768255, 768292-772095, 776114-776127, 776210-776223, 776262-776271, 776308-776319, 776330-776335, 776348-776351, 776354-776383, 776441-776703, 776717-786431
  Free inodes: 182897-190848
Group 24: (Blocks 786432-819199) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x1c83, unused inodes 7952
  Block bitmap at 524296 (bg #16 + 8), Inode bitmap at 524312 (bg #16 + 24)
  Inode table at 528296-528792 (bg #16 + 4008)
  32768 free blocks, 7952 free inodes, 0 directories, 7952 unused inodes
  Free blocks: 786432-819199
  Free inodes: 190849-198800
Group 25: (Blocks 819200-851967) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0xd472, unused inodes 7952
  Backup superblock at 819200, Group descriptors at 819201-819201
  Reserved GDT blocks at 819202-819425
  Block bitmap at 524297 (bg #16 + 9), Inode bitmap at 524313 (bg #16 + 25)
  Inode table at 528793-529289 (bg #16 + 4505)
  32542 free blocks, 7952 free inodes, 0 directories, 7952 unused inodes
  Free blocks: 819426-851967
  Free inodes: 198801-206752
Group 26: (Blocks 851968-884735) [INODE_UNINIT, BLOCK_UNINIT, ITABLE_ZEROED]
  Checksum 0xc0d5, unused inodes 7952
  Block bitmap at 524298 (bg #16 + 10), Inode bitmap at 524314 (bg #16 + 26)
  Inode table at 529290-529786 (bg #16 + 5002)
  32768 free blocks, 7952 free inodes, 0 directories, 7952 unused inodes
  Free blocks: 851968-884735
  Free inodes: 206753-214704
Group 27: (Blocks 884736-917503) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x4a8a, unused inodes 7952
  Backup superblock at 884736, Group descriptors at 884737-884737
  Reserved GDT blocks at 884738-884961
  Block bitmap at 524299 (bg #16 + 11), Inode bitmap at 524315 (bg #16 + 27)
  Inode table at 529787-530283 (bg #16 + 5499)
  32542 free blocks, 7952 free inodes, 0 directories, 7952 unused inodes
  Free blocks: 884962-917503
  Free inodes: 214705-222656
Group 28: (Blocks 917504-921599) [INODE_UNINIT, ITABLE_ZEROED]
  Checksum 0x0c1e, unused inodes 7952
  Block bitmap at 524300 (bg #16 + 12), Inode bitmap at 524316 (bg #16 + 28)
  Inode table at 530284-530780 (bg #16 + 5996)
  4096 free blocks, 7952 free inodes, 0 directories, 7952 unused inodes
  Free blocks: 917504-921599
  Free inodes: 222657-230608

I'm not able to replicate the problem at will so i don't know if upgrading the kernel will fix the problem or not
but i can give more info if you tell me what to do, thanks.

ciao
Luca





