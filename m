Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab3JEGK5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 02:10:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:11596 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab3JEGK4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 02:10:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1038,1371106800"; 
   d="scan'208";a="388203951"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
CC: Greg KH <greg@kroah.com>, Peng Tao <tao.peng@emc.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: lustre: why does cfs_get_random_bytes() exist?
Thread-Topic: lustre: why does cfs_get_random_bytes() exist?
Thread-Index: AQHOwFckUwawBx6iCEW+T1+NaTzynpnjsASAgAAj3QD//9a5AIAAb2uAgAGZW4A=
Date: Sat, 5 Oct 2013 06:10:54 +0000
Message-ID: <CE750681.752DF%andreas.dilger@intel.com>
In-Reply-To: <20131003234545.GA19796@thunk.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.125.217]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3B30AF005B76F3439231F225D4F9F3B2@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/10/03 5:45 PM, "Theodore Ts'o" <tytso@mit.edu> wrote:
>On Thu, Oct 03, 2013 at 11:06:58PM +0000, Dilger, Andreas wrote:
>> 
>> The Lustre cfs_get_random_bytes() incorporates (via cfs_rand()) a seed
>> which also hashes in the addresses from any network interfaces that are
>> configured.
>> Conversely, cfs_rand() also is seeded at startup from
>>get_random_bytes() in
>> case a hardware RNG is available.  This ensures even with identical
>>initial
>> conditions cfs_get_random_bytes() gets a different random stream on each
>> node.
>
>With modern kernels, the /dev/random driver has the
>add_device_randomness() interface which is used to mix in
>personalization information, which includes the network MAC address.
>So that particular concern should be covered without the hack of
>mixing in cfs_rand().

I think that depends on the network driver.  The Cray systems have some
very strange networking hardware that is beyond our control - definitely
not ethernet or Infiniband.

I'll have to ask the Cray folks if their network drivers do this today.

>> I'm not against cleaning this up, if there is some mechanism for the
>> startup code to add in the node interface addresses into the entropy
>> pool, and this is also used to perturb the prandom_u32() sequence
>> after that point.
>
>That's handled too, via the late initcall prandom_reseed().
>
>Cheers,
>
>					- Ted
>


Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


