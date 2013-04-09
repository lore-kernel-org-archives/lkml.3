Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936264Ab3DIU37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 16:29:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933489Ab3DIU36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 16:29:58 -0400
Date: Tue, 9 Apr 2013 16:29:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] x86, kdump: Change crashkernel_high/low= to
 crashkernel=;high/low
Message-ID: <20130409202948.GQ6320@redhat.com>
References: <1365113821-22749-1-git-send-email-yinghai@kernel.org>
 <1365113821-22749-5-git-send-email-yinghai@kernel.org>
 <20130409134544.GA6320@redhat.com>
 <CAE9FiQUETs0AGjd+72GOz=Pm=9QicM7L46OaiMwhtUFa65TTvA@mail.gmail.com>
 <5164790E.7@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5164790E.7@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 01:24:46PM -0700, H. Peter Anvin wrote:
> On 04/09/2013 01:05 PM, Yinghai Lu wrote:
> >>
> >> So crashkernel=X@Y;high is a valid syntax? Looks like we will reserve
> >> X amount of RAM at base Y and ignore "high" or "low".
> > 
> > yes, we should reject them.
> > 
> 
> What if there isn't X amount of RAM available at base Y?

We don't reserve anything.

In this context crashkernel=X@Y,high is invalid syntax and should probably
be ignored by parser. The very fact user specified the offset, high or
low option does not carry any meaning.

crashkernel=X,high is valid though.

Thanks
Vivek
