Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaEZTNV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 15:13:21 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:60711 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaEZTNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 15:13:20 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20140526165858.GC8079@madcap2.tricolour.ca>
References: <cover.1400271129.git.rgb@redhat.com> <CAHO5Pa0EdUsV9jJuLbkmbvFyopecQiUDZd0UasAJ5kMhtsVxjQ@mail.gmail.com>
 <20140526165858.GC8079@madcap2.tricolour.ca>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 26 May 2014 21:12:59 +0200
Message-ID: <CAKgNAkgfV5K6BWjibCVwzJE3GYfmAHNzk+aU05M0xEdrfZmzPg@mail.gmail.com>
Subject: Re: [PATCH V3 0/6] namespaces: log namespaces per task
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        containers <containers@lists.linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, sgrubb@redhat.com,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard

On Mon, May 26, 2014 at 6:58 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 14/05/22, Michael Kerrisk wrote:
>> Richard,
>
> Hi Michael,
>
>> On Tue, May 20, 2014 at 3:12 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
>> > The purpose is to track namespaces in use by logged processes from the
>> > perspective of init_*_ns.
>> >
>> > 1/6 defines a function to generate them and assigns them.
>> >
>> > Use a serial number per namespace (unique across one boot of one kernel)
>> > instead of the inode number (which is claimed to have had the right to change
>> > reserved and is not necessarily unique if there is more than one proc fs).  It
>> > could be argued that the inode numbers have now become a defacto interface and
>> > can't change now, but I'm proposing this approach to see if this helps address
>> > some of the objections to the earlier patchset.
>> >
>> > 2/6 adds access functions to get to the serial numbers in a similar way to
>> > inode access for namespace proc operations.
>> >
>> > 3/6 implements, as suggested by Serge Hallyn, making these serial numbers
>> > available in /proc/self/ns/{ipc,mnt,net,pid,user,uts}_snum.  I chose "snum"
>> > instead of "seq" for consistency with inum and there are a number of other uses
>> > of "seq" in the namespace code.
>> >
>> > 4/6 exposes proc's ns entries structure which lists a number of useful
>> > operations per namespace type for other subsystems to use.
>>
>> Since the 3 and 4 change the ABI, please CC iterations of this patch
>> series to linux-api@vger.kernel.org, as per Documentation/SubmitChecklist.
>
> Neither patch 3/6 nor 4/6 changes the syscall interface.

(Agreed.)

> Patch 3/6 adds /proc/<pid>/ns/ entries, which looks more like #16 in
> that document (for which /proc/<pid>/ns/<nstype> was never added).

But, that's a change to the surface that the kernel exposes to user
space, right? If so, it is best CCed to linux-api.

Thanks,

Michael
