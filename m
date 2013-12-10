Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab3LJTIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:08:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51047 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab3LJTIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:08:40 -0500
Message-ID: <52A766A4.7040202@zytor.com>
Date: Tue, 10 Dec 2013 11:08:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: Binutils <binutils@sourceware.org>, Jiri Kosina <jkosina@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, Josh Boyer <jwboyer@redhat.com>
Subject: Re: RFC: binutils PATCH: Set e_type to ET_EXEC for -pie -Ttext-segment=
References: <CAMe9rOrKGSxr9X5txGq2Js0vGwXdwxPT+ip70-YZs-Wz-aPgQg@mail.gmail.com>
In-Reply-To: <CAMe9rOrKGSxr9X5txGq2Js0vGwXdwxPT+ip70-YZs-Wz-aPgQg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 04:20 AM, H.J. Lu wrote:
> On Mon, Dec 9, 2013 at 8:57 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Where do the _32 and _32S relocations come from?  Are we mixing multiple things inside -pie?
> 
> They come from crt1.o and crtbegin.o.  -pie uses Scrt1.o and crtbeginS.o.
> 

OK, so this is fundamentally an issue with the gcc wrapper... there
isn't a way to get the relocatable crt files without telling the linker
to link PIE (except perhaps using some -Wl option, maybe "-Wl,-no-pie"?)

Either way, if the *only* goal is to get the file above a certain point,
like 4 GiB, then there is no reason not to randomize upward.

	-hpa




