Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab3BRNLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 08:11:22 -0500
Received: from fn.samba.org ([216.83.154.106]:43790 "EHLO mail.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab3BRNLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 08:11:21 -0500
Message-ID: <1361193074.5565.87.camel@jesse>
Subject: Re: Read support for fat_fallocate()? (was [v2] fat: editions to
 support fat_fallocate())
From: Andrew Bartlett <abartlet@samba.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>,
        Nam-Jae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Tue, 19 Feb 2013 00:11:14 +1100
In-Reply-To: <87fw0t26qu.fsf@devron.myhome.or.jp>
References: <1350138661-2454-1-git-send-email-linkinjeon@gmail.com>
	 <1360810114.1727.306.camel@jesse>
	 <CAKYAXd9qmDYivsJduT3bFD2vPOc0DQ0f8RQTxQ7MXXTCQMMQQA@mail.gmail.com>
	 <1360825669.1727.337.camel@jesse>
	 <CAKYAXd9tVzvP_Oa+BoUwKbpaMoVZKZgesDgrLirqoyk6AHrJ2A@mail.gmail.com>
	 <1360900178.1727.393.camel@jesse> <87fw0t26qu.fsf@devron.myhome.or.jp>
Organization: 
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-02-18 at 20:36 +0900, OGAWA Hirofumi wrote:
> Andrew Bartlett <abartlet@samba.org> writes:

> > Or, if we cannot make any changes to the on-disk format, what about
> > keeping such a database in memory, allocating some of the existing free
> > list to files that have had fallocate() called on them?  (Naturally,
> > this makes it non-persistent, and instead more of a 'hint', but could at
> > least solve our mutual performance issues).
> 
> [...]
> 
> Hm. My concerns are compatibility and reliability. Although We can
> change on-disk format if need, but I don't think it can be compatible
> and reliable. If so, who wants to use it? I feel there is no reason to
> use FAT if there is no compatible.
> 
> Well, anyway, possible solution would be, we can pre-allocate physical
> blocks via fallocate(2) or something, but discard pre-allocated blocks
> at ->release() (or before unmount at least). This way would have
> compatibility (no on-disk change over unmount) and possible breakage
> would be same with normal extend write patterns on kernel crash
> (i.e. Windows or fsck will truncate after i_size).

That would certainly give me what the Samba NAS with USB FAT disk use
case needs.

Thanks,

Andrew Bartlett

-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org


