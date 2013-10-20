Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593Ab3JTMWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Oct 2013 08:22:15 -0400
Received: from outbound-ss-330.hostmonster.com ([74.220.205.49]:36146 "HELO
	outbound-ss-330.hostmonster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751326Ab3JTMWO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Oct 2013 08:22:14 -0400
Subject: Re: [RFC] Rollback FS
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Vyacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <CAFLxGvwgf3dD=4Xf_JtFwPFtudRYg8RuL8Jcu5dJr3CfkdnvVg@mail.gmail.com>
Date: Sun, 20 Oct 2013 16:32:12 +0400
Cc: jiaweiwei <jiaweiwei.xiyou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Harry Wei <harryxiyou@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <977288EE-C80D-4808-93E6-E019CA1DDC58@dubeyko.com>
References: <CABjrhvqTHkuEyQ=-xaud5Y0i3YqYcdBsm2eWrR-44V=OESWypg@mail.gmail.com> <F713E780-33E1-494C-ADAD-92211724209E@dubeyko.com> <CABjrhvqLgVSEOJVuS1n-R_kyvhFouUqhfjqS4P_jsPGAec+KdQ@mail.gmail.com> <CAFLxGvwgf3dD=4Xf_JtFwPFtudRYg8RuL8Jcu5dJr3CfkdnvVg@mail.gmail.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
X-Mailer: Apple Mail (2.1085)
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.28 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 20, 2013, at 3:46 PM, Richard Weinberger wrote:

> On Sun, Oct 20, 2013 at 1:37 PM, jiaweiwei <jiaweiwei.xiyou@gmail.com> wrote:
>> On Sun, Oct 20, 2013 at 6:43 PM, Vyacheslav Dubeyko <slava@dubeyko.com> wrote:
>>> Anyway, you need to use Copy-On-Write (COW) approach for such file system.
>>> But there are file systems that implements snapshot approach yet: NILFS2, ext3cow,
>>> Next3, and so on.
>>> 
>> 
>> Any file system should rollback but not specific ones. Therefore, a
>> VFS like mechanism should be designed and implemented.
> 
> -ENOPATCH

Yes, I doubt also that it makes sense to implement such feature on VFS level only.
Anyway, it needs to have support of snapshot feature on concrete file system level.
Otherwise, if it doesn't take into account a concrete file system's internal techniques
then it will have such nonsense as COW under COW. :)

Maybe, VFS needs in transparent rollback support likewise online resize. But such
feature should be based on concrete file systems' internal techniques.

With the best regards,
Vyacheslav Dubeyko.

