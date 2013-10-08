Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3JHB0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 21:26:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33886 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746Ab3JHB0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 21:26:44 -0400
Message-ID: <52535EE1.3060700@zytor.com>
Date: Mon, 07 Oct 2013 18:24:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Dhaval Giani <dhaval.giani@gmail.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>, Rob Clark <robdclark@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 05/14] vrange: Add new vrange(2) system call
References: <1380761503-14509-1-git-send-email-john.stultz@linaro.org> <1380761503-14509-6-git-send-email-john.stultz@linaro.org> <52533C12.9090007@zytor.com> <5253404D.2030503@linaro.org> <52534331.2060402@zytor.com> <52534692.7010400@linaro.org> <525347BE.7040606@zytor.com> <525349AE.1070904@linaro.org> <52534AEC.5040403@zytor.com> <20131008001306.GD25780@bbox>
In-Reply-To: <20131008001306.GD25780@bbox>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2013 05:13 PM, Minchan Kim wrote:
>>
>> The point is that MADV_DONTNEED is very similar in that sense,
>> especially if allowed to be lazy.  It makes a lot of sense to permit
>> both scrubbing modes orthogonally.
>>
>> The point you're making has to do with withdrawal of permission to flush
>> on demand, which is a result of having the lazy mode (ongoing
>> permission) and having to be able to withdraw such permission.
> 
> I'm sorry I could not understand what you wanted to say.
> Could you elaborate a bit?
> 

Basically, you need this because of MADV_LAZY or the equivalent, so it
would be applicable to a similar variant of madvise().

As such I would suggest that an madvise4() call would be appropriate.

	-hpa


