Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423510Ab3FUR3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 13:29:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58393 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423122Ab3FUR3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 13:29:11 -0400
Message-ID: <51C48D5A.4010602@zytor.com>
Date: Fri, 21 Jun 2013 10:28:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nathan Zimmer <nzimmer@sgi.com>
CC: Greg KH <gregkh@linuxfoundation.org>, holt@sgi.com, travis@sgi.com,
        rob@landley.net, tglx@linutronix.de, mingo@redhat.com,
        yinghai@kernel.org, akpm@linux-foundation.org, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <20130621165142.GA32125@kroah.com> <51C48745.9030304@zytor.com> <51C48ADD.207@sgi.com>
In-Reply-To: <51C48ADD.207@sgi.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 10:18 AM, Nathan Zimmer wrote:
>>>
>> Since you made it a compile time option, it would be good to know how
>> much code it adds, but otherwise I agree with Greg here... this really
>> shouldn't need to be an option.  It *especially* shouldn't need to be a
>> hand-set runtime option (which looks quite complex, to boot.)
> The patchset as a whole is just over 400 lines so it doesn't add alot.
> If I were to pull the .config option it would probably remove 30 lines.

I'm more concerned about bytes of code.

> The command line option is too complex but some of the data I haven't
> found a way to get at runtime yet.

I think that is probably key.

>> I suspect the cutoff for this should be a lot lower than 8 TB even, more
>> like 128 GB or so.  The only concern is to not set the cutoff so low
>> that we can end up running out of memory or with suboptimal NUMA
>> placement just because of this.
> Even at lower amounts of ram there is an positive impact.I it knocks
> time off
> boot even at as small as a 1TB of ram.

I am not surprised.

	-hpa

