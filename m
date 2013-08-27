Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab3H0Jj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 05:39:57 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:60802 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab3H0Jjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 05:39:42 -0400
Message-ID: <521C73D7.1010007@linux.vnet.ibm.com>
Date: Tue, 27 Aug 2013 15:09:35 +0530
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>
CC: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>,
        "ccross@android.com" <ccross@android.com>
Subject: Re: [RFC PATCH v2 06/11] pstore: Add decompression support to pstore
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420> <20130816131821.3338.27923.stgit@aruna-ThinkPad-T420> <A5ED84D3BB3A384992CBB9C77DEDA4D443E8F0B8@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D443E8F0B8@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082709-9574-0000-0000-0000095AB3D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 August 2013 04:34 AM, Seiji Aguchi wrote:
>
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Aruna Balakrishnaiah
>> Sent: Friday, August 16, 2013 9:18 AM
>> To: linuxppc-dev@ozlabs.org; tony.luck@intel.com; linux-kernel@vger.kernel.org; keescook@chromium.org
>> Cc: jkenisto@linux.vnet.ibm.com; ananth@in.ibm.com; benh@kernel.crashing.org; cbouatmailru@gmail.com;
>> mahesh@linux.vnet.ibm.com; ccross@android.com
>> Subject: [RFC PATCH v2 06/11] pstore: Add decompression support to pstore
>>
>> Based on the flag 'compressed' set or not, pstore will decompress the
>> data returning a plain text file. If decompression fails for a particular
>> record it will have the compressed data in the file which can be
>> decompressed with 'openssl' command line tool.
> If the decompression fails and openssl doesn't work, the worst case is that users can't read the entry.
> In that case, pstore is meaningless at all.

If decompression fails and openssl doesn't work. We have python module zlib to 
decompress
the zlib data. zlib.decompress() should do the trick.

> Also, for users who want to get a single panic message, a compression is not needed.
>
> So, I think we still have to support non-compression mode.
> (IMO, pstore can take kdump as a model. Kdump supports both compression and non-compression mode.)
>
> But, if you think my comment is outside this patchset, it's OK.
> We can make it with a separate patch.
>
> Seiji
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>

