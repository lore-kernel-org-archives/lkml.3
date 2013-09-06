Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab3IFUDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 16:03:06 -0400
Received: from cobra.newdream.net ([66.33.216.30]:45078 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3IFUDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 16:03:03 -0400
Date: Fri, 6 Sep 2013 13:03:02 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Milosz Tanski <milosz@adfin.com>
cc: sprabhu@redhat.com, ceph-devel <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Hongyi Jia <jiayisuse@gmail.com>,
        "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/8] ceph: fscache support & upstream changes
In-Reply-To: <CANP1eJFMdcsgSwVO9jhYQwn2C+19db1uy5=du7yYFbmiB6em0A@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1309061302300.12830@cobra.newdream.net>
References: <cover.1378418255.git.milosz@adfin.com> <alpine.DEB.2.00.1309051555250.1073@cobra.newdream.net> <CANP1eJEk=eRmq1F+yYWB53spgifbU+zzKGdmKw6BGfx8SknkrA@mail.gmail.com> <18764.1378483142@warthog.procyon.org.uk>
 <CANP1eJFMdcsgSwVO9jhYQwn2C+19db1uy5=du7yYFbmiB6em0A@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Sep 2013, Milosz Tanski wrote:
> Sage,
> 
> I've taken David's latest changes and per his request merged his
> 'fscache-fixes-for-ceph' tag then applied my changes on top of that.
> In addition to the pervious changes I also added a fix for the
> warnings the linux-next build bot found.
> 
> I've given the results a quick test to make sure it builds, boots and
> runs okay. The code is located in my repository:
> 
>   https://adfin@bitbucket.org/adfin/linux-fs.git in the wip-fscache-v2 branch
> 
> I hope that this is the final go for now and thanks for everyone's patience.

Looks good; I'll send this to Linus along with the other ceph patches 
shortly.

Thanks, everyone!
sage


> 
>  - Milosz
> 
> On Fri, Sep 6, 2013 at 11:59 AM, David Howells <dhowells@redhat.com> wrote:
> > Milosz Tanski <milosz@adfin.com> wrote:
> >
> >> After running this for a day on some loaded machines I ran into what
> >> looks like an old issue with the new code. I remember you saw an issue
> >> that manifested it self in a similar way a while back.
> >>
> >> [13837253.462779] FS-Cache: Assertion failed
> >> [13837253.462782] 3 == 5 is false
> >> [13837253.462807] ------------[ cut here ]------------
> >> [13837253.462811] kernel BUG at fs/fscache/operation.c:414!
> >
> > Bah.
> >
> > I forgot to call fscache_op_complete().  Patch updated and repushed.
> >
> > Btw, I've reordered the patches to put the CIFS patch last.  Can you merge the
> > patches prior to the CIFS commit from my branch rather than cherry picking
> > them so that if they go via two different routes, GIT will handle the merge
> > correctly?  I've stuck a tag on it (fscache-fixes-for-ceph) to make that
> > easier for you.
> >
> > I've also asked another RH engineer to try doing some basic testing on the
> > CIFS stuff - which may validate the fscache_readpages_cancel patch.
> >
> > David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
