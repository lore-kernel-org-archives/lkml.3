Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab3IEPPI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:15:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab3IEPPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:15:06 -0400
Date: Thu, 5 Sep 2013 11:14:57 -0400
From: Dave Jones <davej@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ext4: cache all of an extent tree's leaf block upon reading
Message-ID: <20130905151457.GA24177@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20130905013848.42DD7660EE1@gitolite.kernel.org>
 <20130905143749.GA15894@redhat.com>
 <20130905145334.GB23661@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130905145334.GB23661@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 10:53:34AM -0400, Theodore Ts'o wrote:

 > > ext4_es_store_pblock or's the pblk with the existing contents of the struct member.
 > > (albeit masked with ES_MASK)
 > > 
 > > Should there be a 
 > > 
 > > 	newes.es_pblk = 0;
 > > 
 > > up there too ?
 > 
 > The next line after ext4_es_store_pblock() is:
 > 
 >         ext4_es_store_status(&newes, status);
 > 
 > This will set remaining ES_WRITTEN | ES_UNWRITTEN... bits.
 > 
 > So the only reason to add a line explicitly setting es_pblk to zero
 > would be to suppress a warning from some insufficiently smart static
 > code analysis tool.  I didn't see a warning from gcc, but it's
 > possible that this is something which is causing Coverity or some
 > other code scanner heartburn.

Yep, that's what picked it up.  I'll add a 'not a bug' annotation to stop
it getting flagged again.  This was the only ext* issue that Coverity
picked up from yesterdays merge btw, which I guess is good news ;)

	Dave

