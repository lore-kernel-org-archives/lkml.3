Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759420Ab3GRU5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:57:16 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47591 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759359Ab3GRU5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 16:57:14 -0400
Subject: Re: [lustre mess] is mgc_fs_setup() reachable at all?
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <20130718190703.GB4165@ZenIV.linux.org.uk>
Date: Thu, 18 Jul 2013 14:57:11 -0600
Cc: Nathan Rutman <nathan_rutman@xyratex.com>, Peng Tao <bergwolf@gmail.com>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <3F4C226D-9D3B-46FA-9C8C-55268B2F904F@dilger.ca>
References: <20130718090835.GZ4165@ZenIV.linux.org.uk> <CA+a=Yy49WfQVJAYybUzVvigi9b--kuagqKxBEH+yy0RZSKVnQA@mail.gmail.com> <5DD1CAAA-2008-47F9-B3B6-8D342B28D08C@xyratex.com> <20130718190703.GB4165@ZenIV.linux.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-07-18, at 1:07 PM, Al Viro wrote:
> On Thu, Jul 18, 2013 at 11:40:16AM -0700, Nathan Rutman wrote:
>>>>               }
>>>>               RETURN(rc);
>>>>       }
>>>> What is going on here?  We cast something to struct super_block *?
>>>> Where does it come from?  The function it's in is
>> Well, addressing the "what's going on" question without getting
>> into the larger philosophy, keys and values are used as a generic mechanism to pass various items between Lustre clients and servers.
>> In this case, a specific key should only have a value of "a
>> superblock", and so this is just a sanity check to make sure the
>> value length is sane.  It should probably be more of an ASSERT,
>> but we can't reasonably assert on remotely-supplied data.
> 
> What?  Excuse me, but have you seriously been intending to pass
> struct super_block instances around?  Ones that are choke-full of
> pointers to all kinds of things, not to mention a mutex, spinlock,
> etc.?

The set_info() code is also used between modules on the same node.
I don't make any excuses for the cleanliness of this code, which is
why it is in staging and will take time to clean up before even
attempting to get it into fs/.  I apologize that you even had to
look at this code - definitely a twisty maze that needs cleaning.

> _THAT_ was going to be a remotely supplied data?  I really hope I've
> misparsed what you said above...
> 
> And that still leaves the question about the code path that could
> lead to execution of mgc_fs_setup().

The KEY_SET_FS is only used in the server code, not on the client.
The MGC code is shared between client and server to mount the
filesystem and fetch the cluster configuration from the management
server.  In the case of a server mount, it also has to mount the
underlying block device, which isn't true on the client, so this
code is indeed unused.

Cheers, Andreas





