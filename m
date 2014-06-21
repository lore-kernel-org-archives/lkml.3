Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbaFUGvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 02:51:12 -0400
Received: from mout.web.de ([212.227.15.14]:52702 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757474AbaFUGvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 02:51:11 -0400
Message-ID: <53A52B4E.20807@users.sourceforge.net>
Date: Sat, 21 Jun 2014 08:50:54 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@suse.com>
CC: Coccinelle <cocci@systeme.lip6.fr>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Cocci] SmPL for automatic request_firmware_nowait() conversion
References: <20140621015714.GX4841@wotan.suse.de>
In-Reply-To: <20140621015714.GX4841@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:6WggefgAjWbtS3u2Q9c+qKWz4W7wNQFdDeRvfepg+TA+PyWZr8e
 hEmoumWGuau3Md6DjA81u3OyvPSyjR3FNjaJBkfNIkkebu7KPVErEvaE7umIjLuwzmzmQPe
 er04lqKz6W3XiXUa+VltoXs3MCLzT4C0kqnAM/uEy7ivpqXO19vCf+/EmC321FdNJmh2+yH
 Rp97QltIGjCaOVxfg4Seg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Obviously I considered writing SmPL for this, but one thing which seemed
> hard was that for after the request_firmware_nowait() we tend to tuck
> away into another new call the rest of the code that was in place in the
> original function after the old request_firmware() call. Is there a way
> to dump all that code into the new routine?

Does the refactoring "Extraction of an interface" fit also to your use case?
http://refactoring.com/catalog/extractInterface.html
http://c2.com/cgi/wiki?ExtractInterface


> I think the hardest thing would be to also move the right set of variables over.

The current syntax for semantic patches has got some limitations for its
expression power. I guess that it is still a software development challenge to
support also variations in involved statements.


> Its hard for me to think of how I can hint to Coccinelle enough information
> about what stuff it needs to move around. I think one hint would be:
> 
>   "Hey all that code that is static and is used *before* and *after* request_firmware()
>    stuff it into the private data structure"

Do you need dynamic source code introspection here?

Regards,
Markus
