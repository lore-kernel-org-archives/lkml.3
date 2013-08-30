Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab3H3Sdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 14:33:52 -0400
Received: from tuna.sandelman.ca ([209.87.252.184]:59087 "EHLO
	tuna.sandelman.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab3H3Sdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 14:33:51 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Aug 2013 14:33:51 EDT
From: Michael Richardson <mcr@sandelman.ca>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
cc: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
        Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        Jan Kara <jack@suse.cz>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        "J. Bruce Fields" <bfields@redhat.com>, linux-ext4@vger.kernel.org
Subject: Re: [uml-devel] Issues with a rather unusual configured NFS server
In-Reply-To: <CAFLxGvyK5+nB9TgW1uPho9KGwQrWQHx=wEpj+o-mZcN92bWAOg@mail.gmail.com>
References: <52075E01.7030506@gmx.de> <20130812143640.GF4596@quack.suse.cz> <20130813215313.GH17781@fieldses.org> <20130827180655.GE14809@fieldses.org> <521E318C.7040401@gmx.de> <CAFLxGvyK5+nB9TgW1uPho9KGwQrWQHx=wEpj+o-mZcN92bWAOg@mail.gmail.com>
X-Mailer: MH-E 8.2; nmh 1.3-dev; GNU Emacs 23.4.1
X-Face: $\n1pF)h^`}$H>Hk{L"x@)JS7<%Az}5RyS@k9X%29-lHB$Ti.V>2bi.~ehC0;<'$9xN5Ub#
 z!G,p`nR&p7Fz@^UXIn156S8.~^@MJ*mMsD7=QFeq%AL4m<nPbLgmtKK-5dC@#:k
Date: Fri, 30 Aug 2013 14:27:08 -0400
Message-ID: <29555.1377887228@sandelman.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


richard -rw- weinberger <richard.weinberger@gmail.com> wrote:
    >>>> Thanks for the report.  I think I see the problem--after this commit
    >>>> nfs4_set_delegation() failures result in nfs4_put_delegation being
    >>>> called, but nfs4_put_delegation doesn't free the nfs4_file that has
    >>>> already been set by alloc_init_deleg().
    >>>>
    >>>> Let me think about how to fix that....
    >>>
    >>> Sorry for the slow response--can you check whether this fixes the
    >>> problem?
    >>>
    >> Yes.
    >>
    >> With the attached patch the problem can't be reproduced any longer
    >> with the prepared test case and current git kernels.

    > BTW: Is nobody else fuzz testing NFS?  Or are these bugs just more
    > likely to hit on UML?  This is not the first NFS issue found by Toralf
    > using UML and Trinity.

Kernel thread scheduling is likely very different on UML than other
architectures.

My guess is that there could well be be gaps where no kernel thread is
scheduled (because another process is running), followed by resumption of a
thread other than the one which would have been resumed on other
virtualization.

--
]               Never tell me the odds!                 | ipv6 mesh networks [
]   Michael Richardson, Sandelman Software Works        | network architect  [
]     mcr@sandelman.ca  http://www.sandelman.ca/        |   ruby on rails    [

