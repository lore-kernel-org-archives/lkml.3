Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbaIKM1J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:27:09 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:45948 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbaIKM1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:27:06 -0400
MIME-Version: 1.0
In-Reply-To: <27732.1410437386@warthog.procyon.org.uk>
References: <20140910212154.10752.23343.stgit@warthog.procyon.org.uk>
	<20140910212206.10752.21818.stgit@warthog.procyon.org.uk>
	<1410392204.5187.14.camel@dhcp-9-2-203-236.watson.ibm.com>
	<1410435813.5187.36.camel@dhcp-9-2-203-236.watson.ibm.com>
	<27732.1410437386@warthog.procyon.org.uk>
Date: Thu, 11 Sep 2014 15:27:05 +0300
Message-ID: <CACE9dm-4tURS7ZvJ45W81L5d3yaO8VDyvrcn1-SU_6UsHkmuQw@mail.gmail.com>
Subject: Re: [PATCH 2/6] KEYS: Reinstate EPERM for a key type name beginning
 with a '.'
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
        keyrings <keyrings@linux-nfs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 September 2014 15:09, David Howells <dhowells@redhat.com> wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
>
>> On Wed, 2014-09-10 at 19:36 -0400, Mimi Zohar wrote:
>> > On Wed, 2014-09-10 at 22:22 +0100, David Howells wrote:
>> > > Reinstate the generation of EPERM for a key type name beginning with a
>> > > '.' in a userspace call.  Types whose name begins with a '.' are
>> > > internal only.
>>
>> After re-reading your comment and looking at the different types,
>> testing for dot prefixed types now makes sense.  Both dot prefixed types
>> and keyring names are reserved for the kernel.
>
> Are you withdrawing your objection, then?
>

For me, type test looks unrelated to "." prefixed key/keyring names...

The rest of that patch does following:

+ } else if ((description[0] == '.') &&
+                    (strncmp(type, "keyring", 7) == 0)) {
+             ret = -EPERM;
+             goto error2;


I wonder why this test is only disallowing keyrings...
Why not also keys?

keyctl add user ".ring1" Hello @u

keyctl show
  50463278 --alswrv      0     0       \_ user: .ring1


- Dmitry

> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




-- 
Thanks,
Dmitry
