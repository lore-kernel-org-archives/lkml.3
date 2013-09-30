Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab3I3Ro2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:44:28 -0400
Received: from mx12.netapp.com ([216.240.18.77]:2108 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab3I3Ro0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:44:26 -0400
X-IronPort-AV: E=Sophos;i="4.90,1009,1371106800"; 
   d="scan'208";a="95048228"
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
Thread-Index: AQHOrxGOvZ3ZUuiTzUm2hJZkKwekYZnO5LsAgAhvVACAAAa2gIAAARMAgAANuACAABQxAIAAxnuAgACm0ACAACpVgIABe8EAgAAMZoCAAJbAAIAAJwQAgADdJ4CAAo2qAIAAJXMAgAAEpQCAAABWAIAACPYA///wfgCAABN0gP//8DAAgAASEgD//+/0AAACZFGAAAEyqoAAAZUqAAAA8DUA
Date: Mon, 30 Sep 2013 17:44:12 +0000
Message-ID: <1380563050.6501.15.camel@leira.trondhjem.org>
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
In-Reply-To: <5249B21E.70603@itwm.fraunhofer.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.51]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E198D47EDB60A1479EACDF1FB0A84939@hq.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8UHiX2o011738

On Mon, 2013-09-30 at 19:17 +0200, Bernd Schubert wrote:
> It would be nice if there would be way if the file system would get a 
> hint that the target file is supposed to be copy of another file. That 
> way distributed file systems could also create the target-file with the 
> correct meta-information (same storage targets as in-file has).
> Well, if we cannot agree on that, file system with a custom protocol at 
> least can detect from 0 to SSIZE_MAX and then reset metadata. I'm not 
> sure if this would work for pNFS, though.

splice() does not create new files. What you appear to be asking for
lies way outside the scope of that system call interface.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
