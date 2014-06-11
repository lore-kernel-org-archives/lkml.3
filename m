Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaFKWAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 18:00:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41365 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaFKWAX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 18:00:23 -0400
Subject: Re: kmemleak: Unable to handle kernel paging request
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
From: Catalin Marinas <catalin.marinas@arm.com>
In-Reply-To: <CAOJe8K1TgTDX5=LdE9r6c0ami7TRa7zr0hL_uu6YpiWrsePAgQ@mail.gmail.com>
Date: Wed, 11 Jun 2014 23:00:18 +0100
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <B01EB0A1-992B-49F4-93AE-71E4BA707795@arm.com>
References: <CAOJe8K3fy3XFxDdVc3y1hiMAqUCPmkUhECU7j5TT=E=gxwBqHg@mail.gmail.com> <20140611173851.GA5556@MacBook-Pro.local> <CAOJe8K1TgTDX5=LdE9r6c0ami7TRa7zr0hL_uu6YpiWrsePAgQ@mail.gmail.com>
To: Denis Kirjanov <kda@linux-powerpc.org>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 Jun 2014, at 21:04, Denis Kirjanov <kda@linux-powerpc.org> wrote:
> On 6/11/14, Catalin Marinas <catalin.marinas@arm.com> wrote:
>> On Wed, Jun 11, 2014 at 04:13:07PM +0400, Denis Kirjanov wrote:
>>> I got a trace while running 3.15.0-08556-gdfb9454:
>>> 
>>> [  104.534026] Unable to handle kernel paging request for data at
>>> address 0xc00000007f000000
>> 
>> Were there any kmemleak messages prior to this, like "kmemleak
>> disabled"? There could be a race when kmemleak is disabled because of
>> some fatal (for kmemleak) error while the scanning is taking place
>> (which needs some more thinking to fix properly).
> 
> No. I checked for the similar problem and didn't find anything relevant.
> I'll try to bisect it.

Does this happen soon after boot? I guess it’s the first scan
(scheduled at around 1min after boot). Something seems to be telling
kmemleak that there is a valid memory block at 0xc00000007f000000.

Catalin