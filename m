Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbaDXNd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:33:29 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:53170 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbaDXNdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:33:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140424103639.GC19564@arm.com>
References: <1397648803-15961-1-git-send-email-steve.capper@linaro.org>
	<20140424102229.GA28014@linaro.org>
	<20140424103639.GC19564@arm.com>
Date: Thu, 24 Apr 2014 08:33:19 -0500
Message-ID: <CAL_JsqLC4GzVXQ0ei26JEn5cL9JdmfYUr31_qGgUvU2HyezBWQ@mail.gmail.com>
Subject: Re: [PATCH V2 0/5] Huge pages for short descriptors on ARM
From: Rob Herring <robherring2@gmail.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Steve Capper <steve.capper@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "gerald.schaefer@de.ibm.com" <gerald.schaefer@de.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 5:36 AM, Will Deacon <will.deacon@arm.com> wrote:
> Hi Steve,
>
> On Thu, Apr 24, 2014 at 11:22:29AM +0100, Steve Capper wrote:
>> On Wed, Apr 16, 2014 at 12:46:38PM +0100, Steve Capper wrote:

[...]

>> I'm not sure how to proceed with these patches. I was thinking that
>> they could be picked up into linux-next? If that sounds reasonable;
>> Andrew, would you like to take the mm/ patch and Russell could you
>> please take the arch/arm patches?
>>
>> Also, I was hoping to get these into 3.16. Are there any objections to
>> that?
>
> Who is asking for this code? We already support hugepages for LPAE systems,
> so this would be targetting what? A9? I'm reluctant to add ~400 lines of
> subtle, low-level mm code to arch/arm/ if it doesn't have any active users.

I can't really speak to the who so much anymore. I can say on the
server front, it was not only Calxeda asking for this.

Presumably there are also performance benefits on older systems even
with 128MB-1GB of RAM. Given that KVM guests can only use 3GB of RAM,
enabling LPAE in guest kernels has little benefit. So this may still
be useful on LPAE capable systems. Also, Oracle Java will use
hugetlbfs if available and Java performance needs all the help it can
get.

> I guess I'm after some commitment that this is (a) useful to somebody and
> (b) going to be tested regularly, otherwise it will go the way of things
> like big-endian, where we end up carrying around code which is broken more
> often than not (although big-endian is more self-contained).

One key difference here is enabling THP is or should be transparent
(to state the obvious) to users. While the BE code itself may be
self-contained, using BE is very much not in that category.
Potentially every driver on a platform could be broken for BE. Case in
point, the Calxeda xgmac driver is broken on BE due to using __raw i/o
accessors instead of relaxed variants.

Rob
