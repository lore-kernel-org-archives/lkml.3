Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322Ab3EBPXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:23:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:34382 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757340Ab3EBPXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:23:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,597,1363158000"; 
   d="scan'208";a="330358976"
Message-ID: <518284E6.7040503@intel.com>
Date: Thu, 02 May 2013 08:23:18 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Winkler, Tomas" <tomas.winkler@intel.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "SamuelOrtiz@kroah.com" <SamuelOrtiz@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mei file2alias compile error
References: <51814943.7000604@intel.com> <20130501182138.GA17550@kroah.com> <5B8DA87D05A7694D9FA63FD143655C1B01F18E66@HASMSX106.ger.corp.intel.com>
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B01F18E66@HASMSX106.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 11:50 PM, Winkler, Tomas wrote:
>> On Wed, May 01, 2013 at 09:56:35AM -0700, Dave Hansen wrote:
>>> Linus's current git isn't compiling for me:
>>>>   HOSTCC  scripts/mod/file2alias.o
>>>> /home/davehans/linux.git/scripts/mod/file2alias.c: In function
>> ‘do_mei_entry’:
>>>> /home/davehans/linux.git/scripts/mod/file2alias.c:1140:1: error:
>> ‘OFF_mei_cl_device_id_name’ undeclared (first use in this function)
>>>> /home/davehans/linux.git/scripts/mod/file2alias.c:1140:1: note: each
>> undeclared identifier is reported only once for each function it appears in
>>>> /home/davehans/linux.git/scripts/mod/file2alias.c: At top level:
>>>> /home/davehans/linux.git/scripts/mod/file2alias.c:1146:1: error:
>> ‘SIZE_mei_cl_device_id’ undeclared here (not in a function)
>>>
>>> I confirmed that this commit: e5354107e is the one causing it for me.
>>> My .config is here:
>>>
>>> 	http://sr71.net/~dave/linux/config-3.9-meibad
>>>
>>> Note that I don't even have CONFIG_INTEL_MEI enabled with this config.
>>
>> I don't have CONFIG_INTEL_MEI set either, and I can't duplicate this.
>> Samuel and Tomas, can you please track this down?
> 
> I cannot reproduce it as well. I've tried with v3.9 and also with the latest tip.

I did some more poking around.  I was building with O= to put the
binaries in another dir.  When I saw the error, one of the first things
I did was do a "make mrproper" on the binary directory.  But, I never
did one one the source directory.  Doing that seems to have made this go
away.  There must have been some build gunk in the source directory
causing this.

Tomas, thanks for taking a look.

For posterity:

gcc version 4.6.3 20120306 (Red Hat 4.6.3-2) (GCC)
Fedora release 16 (Verne)
v3.9-5295-ga49fe6d
