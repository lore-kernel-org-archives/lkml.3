Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbaGURdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:33:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44808 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932363AbaGURdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:33:16 -0400
Message-ID: <53CD4EB2.5020709@zytor.com>
Date: Mon, 21 Jul 2014 10:32:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, tglx@linutronix.de,
        mingo@redhat.com, akpm@linux-foundation.org, arnd@arndb.de,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stefan.bader@canonical.com,
        luto@amacapital.net, airlied@gmail.com, bp@alien8.de
Subject: Re: [RFC PATCH 0/11] Support Write-Through mapping on x86
References: <1405452884-25688-1-git-send-email-toshi.kani@hp.com>		 <53C58A69.3070207@zytor.com> <1405459404.28702.17.camel@misato.fc.hp.com>		 <03d059f5-b564-4530-9184-f91ca9d5c016@email.android.com>		 <1405546127.28702.85.camel@misato.fc.hp.com>	 <1405960298.30151.10.camel@misato.fc.hp.com> <53CD443A.6050804@zytor.com> <1405962993.30151.35.camel@misato.fc.hp.com>
In-Reply-To: <1405962993.30151.35.camel@misato.fc.hp.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 10:16 AM, Toshi Kani wrote:
> 
> You are right.  I was under a wrong impression that
> __change_page_attr() always splits a large pages into 4KB pages, but I
> overlooked the fact that it can handle a large page as well.  So, this
> approach does not work...
> 

If it did it would be a major fail.

>> I would also like a systematic way to deal with the fact
>> that Xen (sigh) is stuck with a separate mapping system.
>>
>> I guess Linux could adopt the Xen mappings if that makes it easier, as
>> long as that doesn't have a negative impact on native hardware -- we can
>> possibly deal with some older chips not being optimal.  
> 
> I see.  I agree that supporting the PAT bit is the right direction, but
> I do not know how much effort we need.  I will study on this.
> 
>> However, my thinking has been to have a "reverse PAT" table in memory of memory
>> types to encodings, both for regular and large pages.
> 
> I am not clear about your idea of the "reverse PAT" table.  Would you
> care to elaborate?  How is it different from using pte_val() being a
> paravirt function on Xen?

First of all, paravirt functions are the root of all evil, and we want
to reduce and eliminate them to the utmost level possible.  But yes, we
could plumb that up that way if we really need to.

What I'm thinking of is a table which can deal with both the moving PTE
bit, Xen, and the scattered encodings by having a small table from types
to encodings, and not use the encodings directly until fairly late it
the pipe.  I suspect, but I'm not sure, that we would also need the
inverse operation.

	-hpa


