Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbaB0RXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 12:23:15 -0500
Received: from mailapp01.imgtec.com ([195.89.28.114]:39661 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbaB0RXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 12:23:12 -0500
X-Greylist: delayed 1027 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Feb 2014 12:23:12 EST
Message-ID: <530F707A.8060603@imgtec.com>
Date: Thu, 27 Feb 2014 17:06:02 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Borislav Petkov <bp@alien8.de>, Joe Perches <joe@perches.com>,
        Ben Pfaff <blp@nicira.com>, Christopher Li <sparse@chrisli.org>,
        Josh Triplett <josh@joshtriplett.org>, <linux-sparse@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] sparse: Allow override of sizeof(bool) warning
References: <20140227022857.GC23659@thin> <1393469594.24588.71.camel@joe-AO722> <20140227025845.GA25145@thin> <530EB103.5070406@zytor.com> <1393472326.24588.82.camel@joe-AO722> <60797a1a-1a83-468e-9629-abf4e8712d65@email.android.com> <20140227082529.GA18210@pd.tnic> <dbc47544-a6f6-4ab4-80b0-25d93a1666e2@email.android.com> <20140227152435.GA7982@thunk.org> <530F5E53.5070208@zytor.com> <20140227161004.GT26722@mwanda> <530F6D43.5020006@zytor.com>
In-Reply-To: <530F6D43.5020006@zytor.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/14 16:52, H. Peter Anvin wrote:
> On 02/27/2014 08:10 AM, Dan Carpenter wrote:
>>
>> That last assumption has to change for the Meta architecture.
>>
>> https://lwn.net/Articles/522188/
>>
>> On meta, the structs and unions are padded to 4 bytes unless they are
>> explicitly marked as __packed.
>>
> 
> One have to wonder how likely they are to have that not continually break...

Well it's only when it deals with stored/portable data formats that it's
an issue, and in those cases some amount of care over packing has
usually already been taken. It most often causes problems when one small
struct/union containing only chars or shorts is nested inside another
struct which is marked as packed (on the unfortunately mistaken
assumption that the inner struct cannot have padding at the end so
doesn't need packing itself).

But yeh, it is a PITA.

Cheers
James
