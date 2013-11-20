Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab3KTQ0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:26:36 -0500
Received: from zill.ext.symas.net ([69.43.206.106]:40627 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab3KTQ0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:26:33 -0500
X-Greylist: delayed 1395 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Nov 2013 11:26:33 EST
Message-ID: <528CDD19.5060002@symas.com>
Date: Wed, 20 Nov 2013 08:02:33 -0800
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:27.0) Gecko/20100101 Firefox/27.0 SeaMonkey/2.24a1
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Chinmay V S <cvs268@gmail.com>,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        matthew@wil.cx
Subject: Re: Why is O_DSYNC on linux so slow / what's wrong with my SSD?
References: <528CA73B.9070604@profihost.ag> <20131120125446.GA6284@infradead.org> <CAK-9PRAManphkxT3ub0DfW8hx=xbq+ZeqUB0E0CEnFTfF7AQuw@mail.gmail.com> <528CC36A.7080003@profihost.ag> <CAK-9PRDyGhXPef-Vbt83Os-oowFZ2HzSZVY9PH3rSdnTwNmf2w@mail.gmail.com> <20131120153703.GA23160@thunk.org>
In-Reply-To: <20131120153703.GA23160@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o wrote:
> Historically, Intel has been really good about avoiding this, but
> since they've moved to using 3rd party flash controllers, I now advise
> everyone who plans to use any flash storage, regardless of the
> manufacturer, to do their own explicit power fail testing (hitting the
> reset button is not good enough, you need to kick the power plug out
> of the wall, or better yet, use a network controlled power switch you
> so you can repeat the power fail test dozens or hundreds of times for
> your qualification run) before being using flash storage in a mission
> critical situation where you care about data integrity after a power
> fail event.

Speaking of which, what would you use to automate this sort of test? I'm 
thinking an SSD connected by eSATA, with an external power supply, and the 
host running inside a VM. Drop power to the drive at the same time as doing a 
kill -9 on the VM, then you can resume the VM pretty quickly instead of 
waiting for a full reboot sequence.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
