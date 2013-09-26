Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab3IZNVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 09:21:08 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:48361 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757113Ab3IZNUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 09:20:50 -0400
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
From: joeyli <jlee@suse.com>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Pavel Machek <pavel@ucw.cz>, Alan Stern <stern@rowland.harvard.edu>,
        David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
        opensuse-kernel@opensuse.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <len.brown@intel.com>,
        Josh Boyer <jwboyer@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
In-Reply-To: <20130926122210.GA30225@suse.cz>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
	 <1380161957.32302.42.camel@linux-s257.site>
	 <1380192218.32302.69.camel@linux-s257.site>
	 <20130926120621.GA7537@amd.pavel.ucw.cz>  <20130926122210.GA30225@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Sep 2013 21:20:38 +0800
Message-ID: <1380201638.32302.90.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2013-09-26 於 14:22 +0200，Vojtech Pavlik 提到：
> On Thu, Sep 26, 2013 at 02:06:21PM +0200, Pavel Machek wrote:
> 
> > > For the symmetric key solution, I will try HMAC (Hash Message
> > > Authentication Code). It's already used in networking, hope the
> > > performance is not too bad to a big image.
> > 
> > Kernel already supports crc32 of the hibernation image, you may want
> > to take a look how that is done.
> > 
> > Maybe you want to replace crc32 with cryptographics hash (sha1?) and
> > then use only hash for more crypto? That way speed of whatever
> crypto
> > you do should not be an issue.
> 
> Well, yes, one could skip the CRC when the signing is enabled to gain
> a
> little speedup. 

In current kernel, CRC is for check the integrity of LZO compressed
image, the purpose is different to check the integrity of snapshot
image.
So, CRC will not in non-compress hibernate or userspace hibernate code
path

On the other hand, attacker can easily change the CRC code in the header
of LZO hibernate image.

Thanks a lot!
Joey Lee

