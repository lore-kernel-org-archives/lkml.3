Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab3DBPkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 11:40:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491Ab3DBPkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 11:40:17 -0400
Date: Tue, 2 Apr 2013 11:39:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kexec: use Crash kernel for Crash kernel low
Message-ID: <20130402153957.GG29506@redhat.com>
References: <20130401192606.GA17951@redhat.com>
 <5159F27E.7060300@zytor.com>
 <CAE9FiQXikU8-FkYYULHx50qP_ME2bRSzCC=8ZH8iDyUr2ug66g@mail.gmail.com>
 <515A03DB.6040107@zytor.com>
 <CAE9FiQWNFbFgXafJBvORRax+GNU_uf0KFnqZ5NQit0BeZZx9LA@mail.gmail.com>
 <515A083B.7050508@zytor.com>
 <CAE9FiQXwy8nLRQAiZ+P56fokisUXAmTJWA07TZ-gSH61K5FQLA@mail.gmail.com>
 <CAE9FiQW1RzP5A_82qUP7gF_6-G3+Ceay_L1FQf7N=MMbQA4+iw@mail.gmail.com>
 <20130402135001.GC29506@redhat.com>
 <CAE9FiQVWprV4YkMq_Pu95AYk_qGzXWPVBWJVDfa=0RbqL63y4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVWprV4YkMq_Pu95AYk_qGzXWPVBWJVDfa=0RbqL63y4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 07:45:36AM -0700, Yinghai Lu wrote:

[..]
> 2. keep thing unified when new kexec-tools is used: always high.

I think this is wrong. What if system does not have more than 4G of
memory. crashkernel=x,high will fail. So just because we have new version
of kexec-tools, it does not mean that one can always use crashkernel=x,high.

I think we should do two things.

- Extend crashkernel=X to search for memory below 896M, 4G, MAXMEM in
  that order. To me, this will work best for most of the users.

- For users who really care to not allocate memory in low memory ranges,
  they can use crashkernel=X,high. But even there syntax should be that
  look for memory in higher ranges first otherwise allocate from low
  regions.

  Otherwise it makes life very difficult for a user when there is no
  memory available in higher addresses but it is available in low addresses.
  How does one automate that.

In current form, I double crashkernel=X,high is going to be very useful.

Thanks
Vivek
