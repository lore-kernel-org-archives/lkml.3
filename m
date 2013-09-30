Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab3I3Tec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 15:34:32 -0400
Received: from mx11.netapp.com ([216.240.18.76]:3915 "EHLO mx11.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180Ab3I3Te3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:34:29 -0400
X-IronPort-AV: E=Sophos;i="4.90,1009,1371106800"; 
   d="scan'208";a="54962060"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
CC: Miklos Szeredi <miklos@szeredi.hu>, Ric Wheeler <rwheeler@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>, Zach Brown <zab@redhat.com>,
        "Anna Schumaker" <schumaker.anna@gmail.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "Schumaker, Bryan" <Bryan.Schumaker@netapp.com>,
        "Martin K. Petersen" <mkp@mkp.net>, Jens Axboe <axboe@kernel.dk>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Eric Wong <normalperson@yhbt.net>
Subject: Re: [RFC] extending splice for copy offloading
Thread-Topic: [RFC] extending splice for copy offloading
Thread-Index: AQHOrxGOvZ3ZUuiTzUm2hJZkKwekYZnO5LsAgAhvVACAAAa2gIAAARMAgAANuACAABQxAIAAxnuAgACm0ACAACpVgIABe8EAgAAMZoCAAJbAAIAAJwQAgADdJ4CAAo2qAIAAJXMAgAAEpQCAAABWAIAACPYA///wfgCAABN0gP//8DAAgAASEgD//+/0AAACZFGAAAEyqoAAAZUqAAAA8DUAAAAqeIAAAHXeAAABqbqAAAGPWoA=
Date: Mon, 30 Sep 2013 19:34:26 +0000
Message-ID: <1380569663.6501.63.camel@leira.trondhjem.org>
References: <20130930143432.GG16579@fieldses.org>
			 <CAJfpeguMCzv-UhrXrG7e9Q7F_0aEe3_ZMumFwLu3hxcewA_7gA@mail.gmail.com>
			 <52499026.3090802@redhat.com>
			 <CAJfpegtpXuh9070ALGy16Y8kdgioBqSf4JQqBBCF4FHvFJWAWQ@mail.gmail.com>
			 <52498AA8.2090204@redhat.com>
			 <CAJfpegv_C6cLOuA-mNtgtf2QbmmmcHwjQVo8mAnhf_wbJ8iRhg@mail.gmail.com>
			 <52498DB6.7060901@redhat.com>
			 <CAJfpegsvrr7x3MbdpvxUmzq0ZfDHfZkzAar6Od2G7wg8DgPLYQ@mail.gmail.com>
			 <52498F68.8050200@redhat.com>
			 <CAJfpegvvN_5c5oMv8UoODXQHc-DQnijhOtPDXmNamVpQLDoWMQ@mail.gmail.com>
			 <20130930163159.GA14242@tucsk.piliscsaba.szeredi.hu>
			 <5249B21E.70603@itwm.fraunhofer.de>
		 <1380563050.6501.15.camel@leira.trondhjem.org>
		 <5249B987.8020807@itwm.fraunhofer.de>
	 <1380564126.6501.23.camel@leira.trondhjem.org>
	 <5249C7C7.7020207@itwm.fraunhofer.de>
In-Reply-To: <5249C7C7.7020207@itwm.fraunhofer.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BDD3E842D40FC845871979F58BBAC187@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8UJYd3v012310

On Mon, 2013-09-30 at 20:49 +0200, Bernd Schubert wrote:
> On 09/30/2013 08:02 PM, Myklebust, Trond wrote:
> > On Mon, 2013-09-30 at 19:48 +0200, Bernd Schubert wrote:
> >> On 09/30/2013 07:44 PM, Myklebust, Trond wrote:
> >>> On Mon, 2013-09-30 at 19:17 +0200, Bernd Schubert wrote:
> >>>> It would be nice if there would be way if the file system would get a
> >>>> hint that the target file is supposed to be copy of another file. That
> >>>> way distributed file systems could also create the target-file with the
> >>>> correct meta-information (same storage targets as in-file has).
> >>>> Well, if we cannot agree on that, file system with a custom protocol at
> >>>> least can detect from 0 to SSIZE_MAX and then reset metadata. I'm not
> >>>> sure if this would work for pNFS, though.
> >>>
> >>> splice() does not create new files. What you appear to be asking for
> >>> lies way outside the scope of that system call interface.
> >>>
> >>
> >> Sorry I know, definitely outside the scope of splice, but in the context
> >> of offloaded file copies. So the question is, what is the best way to
> >> address/discuss that?
> >
> > Why does it need to be addressed in the first place?
> 
> An offloaded copy is still not efficient if different storage 
> servers/targets used by from-file and to-file.

So? 

> >
> > What is preventing an application from retrieving and setting this
> > information using standard libc functions such as fstat()+open(), and
> > supplemented with libattr attr_setf/getf(), and libacl acl_get_fd/set_fd
> > where appropriate?
> >
> 
> At a minimum this requires network and metadata overhead. And while I'm 
> working on FhGFS now, I still wonder what other file system need to do - 
> for example Lustre pre-allocates storage-target files on creating a 
> file, so file layout changes mean even more overhead there.

The problem you are describing is limited to a narrow set of storage
architectures. If copy offload using splice() doesn't make sense for
those architectures, then don't implement it for them.
You might be able to provide ioctls() to do these special hinted file
creations for those filesystems that need it, but the vast majority
don't, and you shouldn't enforce it on them.

> Anyway, if we could agree on to use libattr or libacl to teach the file 
> system about the upcoming splice call I would be fine.

libattr and libacl are generic libraries that exist to manipulate xattrs
and acls. They do not need to contain Lustre-specific code.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
