Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbbAVCJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 21:09:41 -0500
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:4970 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751683AbbAVCJe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 21:09:34 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'Rusty Russell'" <rusty@rustcorp.com.au>,
        "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
        "'jani.nikula@intel.com'" <jani.nikula@intel.com>,
        "'hch@infradead.org'" <hch@infradead.org>,
        "'hare@suse.de'" <hare@suse.de>,
        "'keescook@chromium.org'" <keescook@chromium.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Thu, 22 Jan 2015 10:07:49 +0800
Subject: RE: [RFC] export module parameters even the permission is zero
Thread-Topic: [RFC] export module parameters even the permission is zero
Thread-Index: AdA0fAxtvSgpGFLyT9Cj+L6dkHJOwABbAMjQ
Message-ID: <35FD53F367049845BC99AC72306C23D1044A02027DE0@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103EDAF89E1A3@CNBJMBX05.corpusers.net>
 <87lhkyarnc.fsf@rustcorp.com.au>
In-Reply-To: <87lhkyarnc.fsf@rustcorp.com.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Rusty Russell [mailto:rusty@rustcorp.com.au]
> Sent: Tuesday, January 20, 2015 2:33 PM
> To: Wang, Yalin; 'akpm@linux-foundation.org'; 'jani.nikula@intel.com';
> 'hch@infradead.org'; 'hare@suse.de'; 'keescook@chromium.org'; 'linux-
> kernel@vger.kernel.org'
> Subject: Re: [RFC] export module parameters even the permission is zero
> 
> "Wang, Yalin" <Yalin.Wang@sonymobile.com> writes:
> > This patch make sure to export module parameters even the permission
> > is zero, this is useful for some platforms like Android, the init
> > process can change the parameter mode/owner by chmod/chown during
> > bootup
> >
> > Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> 
> Hi!
> 
>         Unfortunately, this won't work.  Various parts of the code assume
> that 0 permissions means "cannot be changed or read", so this change would
> introduce many bugs (eg. the parameter could be __initdata).
> 
> Since these are owned by root at boot, changing mode and owner should still
> work.  However, you can't make a read-only field writable and expect it to
> work.
> 
Oh, I see,
This means kernel cmdline can change this module_parameter ignored permission,

Thanks for your comments.
