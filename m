Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab3JKPx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 11:53:59 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:58813 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab3JKPx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 11:53:58 -0400
MIME-Version: 1.0
In-Reply-To: <20131011095139.GA24613@x2.net.home>
References: <20131009232642.GA12776@jtriplet-mobl1>
	<1381447702-6240-1-git-send-email-dianders@chromium.org>
	<20131011095139.GA24613@x2.net.home>
Date: Fri, 11 Oct 2013 08:53:57 -0700
X-Google-Sender-Auth: J2NEcNW47UgGoIBzx_cwXWCE3Hk
Message-ID: <CAD=FV=WKp-QYZf+t8fk_iYw3rDtZz7=Neg=S8pwPw_=e-4AnKQ@mail.gmail.com>
Subject: Re: [PATCH] partitions/efi: treat size mismatch as a warning, not an error
From: Doug Anderson <dianders@chromium.org>
To: Karel Zak <kzak@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Matt Fleming <matt.fleming@intel.com>,
        Sean Paul <seanpaul@chromium.org>, Olof Johansson <olof@lixom.net>,
        Bill Richardson <wfrichar@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Davidlohr Bueso <davidlohr@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karel,

On Fri, Oct 11, 2013 at 2:51 AM, Karel Zak <kzak@redhat.com> wrote:
> On Thu, Oct 10, 2013 at 04:28:22PM -0700, Doug Anderson wrote:
>> +      *
>> +      * Consider a bad value here to be a warning to support dd-ing
>> +      * an image from a smaller disk to a bigger disk.
>>        */
>>       if (ret == GPT_MBR_PROTECTIVE) {
>>               sz = le32_to_cpu(mbr->partition_record[part].size_in_lba);
>>               if (sz != (uint32_t) total_sectors - 1 && sz != 0xFFFFFFFF)
>> -                     ret = 0;
>> +                     pr_warn("%s: mbr size mismatch (%u != %u)\n", __func__,
>> +                             sz, (uint32_t)((uint32_t) total_sectors - 1));
>>       }
>
>  I did the same change to util-linux v2.24 fdisk, so you can use the fdisk
>  to update your protective MBR and boot without warnings.

Yup, I think we've come up with a number of ways that we can update
the partition table to avoid the problems.  :)  ...but the "feature"
that used to work was being able to dd an image from a smaller disk
onto a larger disk and have it "just boot" (though perhaps with some
warning messages).  This feature was used in the Chrome OS workflow to
create bootable USB sticks / SD cards.  We certainly could say that
what the Chrome OS workflow is doing is illegal / bad / unethical, but
it has been working for years and it would be nice for it to keep
working if possible.  :)

http://xkcd.com/1172/

-Doug
