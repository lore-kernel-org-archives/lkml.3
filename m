Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaBYKXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:23:25 -0500
Received: from gproxy4-pub.mail.unifiedlayer.com ([69.89.23.142]:47890 "HELO
	gproxy4-pub.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750735AbaBYKXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:23:21 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Feb 2014 05:23:21 EST
X-Authority-Analysis: v=2.1 cv=F57EKMRN c=1 sm=1 tr=0
 a=yEjhGPV9XlbPNRGz7jjbow==:117 a=yEjhGPV9XlbPNRGz7jjbow==:17 a=DsvgjBjRAAAA:8
 a=f5113yIGAAAA:8 a=G0W75ifUKZMA:10 a=neHJxMmKCwgA:10 a=IkcTkHD0fZMA:10
 a=wCmvBT1CAAAA:8 a=sXxnF9VgnFIA:10 a=djd9j7hWnewA:10 a=kEh0eDnLd4Op7i3ltIYA:9
 a=zaRNWtf9gus9lOs_:21 a=M6ogAZ9ZfiSDdC8R:21 a=QEXdDO2ut3YA:10
Message-ID: <1393323379.2233.13.camel@slavad-CELSIUS-H720>
Subject: Re: [PATCH 1/1] hfsplus: fix longname handling
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: sougata santra <sougata@tuxera.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 25 Feb 2014 14:16:19 +0400
In-Reply-To: <530C6AD5.90905@tuxera.com>
References: <1393270107.27792.9.camel@ultrabook>
	 <1393313845.2233.9.camel@slavad-CELSIUS-H720> <530C6AD5.90905@tuxera.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.92 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 12:05 +0200, sougata santra wrote:

> 		return err;
> >> +
> >> +	len = be16_to_cpu(key->cat.name.length);
> >>   	key->key_len = cpu_to_be16(6 + 2 * len);
> >
> > I think that maybe it is time to change hardcoded 6 on sensible named
> > constant. What do you think?
> 
> I agree, although I think this should he done in a separate patch. Also 
> there are other instances of hard-coding. We can clean them with a patch. ?
> 

Yes, I think so too. It will be great.

> >   62
> >   63         ustrlen = be16_to_cpu(name->length);
> >
> > I suppose that it makes sense to check name->length here and return
> > error. We can check possible volume corruption here.
> 
> I looked into it while writing the patch. I think this was already 
> handled before. Please see. catalog.c#hfsplus_find_cat the only place it 
> is called.
> 
> {code}
>          if (be16_to_cpu(tmp.thread.nodeName.length) > 255) {
>                  pr_err("catalog name length corrupted\n");
>                  return -EIO;
>          }
> {code}
> 

OK. I agree that my suggestion is not necessary.

Thanks,
Vyacheslav Dubeyko.


