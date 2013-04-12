Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3DLK40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 06:56:26 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:39873 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab3DLK4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 06:56:25 -0400
Message-ID: <5167E853.4080209@mev.co.uk>
Date: Fri, 12 Apr 2013 11:56:19 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130410 Thunderbird/17.0.5
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: David Howells <dhowells@redhat.com>, Ian Abbott <ian.abbott@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Mori Hess <fmhess@users.sourceforge.net>,
        David Schleef <ds@schleef.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 05/26] comedi: Don't use create_proc_read_entry() [RFC]
References: <5166D1BB.3070101@mev.co.uk> <20130411132739.32763.82609.stgit@warthog.procyon.org.uk> <20130411132819.32763.72806.stgit@warthog.procyon.org.uk> <23048.1365693352@warthog.procyon.org.uk> <20130411190531.GA32045@kroah.com>
In-Reply-To: <20130411190531.GA32045@kroah.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-04-11 20:05, Greg Kroah-Hartman wrote:
> On Thu, Apr 11, 2013 at 04:15:52PM +0100, David Howells wrote:
>> Ian Abbott <abbotti@mev.co.uk> wrote:
>>
>>>> Don't use create_proc_read_entry() as that is deprecated, but rather use
>>>> proc_create_data() and seq_file instead.
>>>
>>> It seems to work okay and is simpler than I thought it would be!  You changed
>>> the mode of the file to 0644 for some reason though.  Please change it back to
>>> 0444 or S_IFREG | S_IRUGO.  Thanks.
>>
>> Ah... cut'n'paste error.  Sorry about that.
>
> I can fix that up by hand when I apply it, no worries.

You may need to sync with linux-next first, particularly commit 
e784788ddb7000dbea8bd2986a3f83c4d77f96ff by Al Viro "get rid of a bunch 
of open-coded create_proc_read_entry()".

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
