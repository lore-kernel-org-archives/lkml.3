Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbbAVDvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 22:51:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbbAVDvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 22:51:41 -0500
Date: Wed, 21 Jan 2015 21:51:26 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Li Bin <huawei.libin@huawei.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com, guohanjun@huawei.com,
        zhangdianfang@huawei.com, xiexiuqi@huawei.com
Subject: Re: [PATCH 2/2] livepatch: disable/enable_patch manners for
 interdependent patches
Message-ID: <20150122035126.GB12927@treble.redhat.com>
References: <1421831262-27869-1-git-send-email-huawei.libin@huawei.com>
 <1421831262-27869-3-git-send-email-huawei.libin@huawei.com>
 <alpine.LNX.2.00.1501211506420.10817@pobox.suse.cz>
 <54C04775.1070908@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54C04775.1070908@huawei.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 08:42:29AM +0800, Li Bin wrote:
> On 2015/1/21 22:08, Jiri Kosina wrote:
> > On Wed, 21 Jan 2015, Li Bin wrote:
> > By this you limit the definition of the patch inter-dependency to just 
> > symbols. But that's not the only way how patches can depend on it other -- 
> > the dependency can be semantical.
> 
> Yes, I agree with you. But I think the other dependencies such as semantical
> dependency should be judged by the user, like reverting a patch from git repository.
> Right?

But with live patching, there are two users: the patch creator (who
creates the patch module) and the end user (who loads it on their
system).

We can assume the patch creator knows what he's doing, but the end user
doesn't always know or care about low level details like patch
dependencies.  The easiest and safest way to protect the end user is the
current approach, which assumes that each patch depends on all
previously applied patches.

-- 
Josh
