Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaETCPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 22:15:35 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:51553 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaETCPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 22:15:34 -0400
MIME-Version: 1.0
In-Reply-To: <1400551571.10728.31.camel@pippen.local.home>
References: <20140516140215.149535442@goodmis.org> <20140516140502.340008258@goodmis.org>
 <1400509775.1742.15.camel@leonhard> <1400551571.10728.31.camel@pippen.local.home>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 20 May 2014 02:15:13 +0000
X-Google-Sender-Auth: jq2Ki8_Yzoenpa1mg5mS5u42Qr8
Message-ID: <CAM9d7cgniY9A8EJjP6Wey+3a76=94Tgs_Zmf+N8X56xaJ9jGjw@mail.gmail.com>
Subject: Re: [PATCH 2/4] tools lib traceevent: Add options to plugins
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 2:06 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Mon, 2014-05-19 at 23:29 +0900, Namhyung Kim wrote:
>> 2014-05-16 (금), 10:02 -0400, Steven Rostedt:

>> > -struct plugin_option {
>> > -   struct plugin_option            *next;
>> > +struct pevent_plugin_option {
>> > +   struct pevent_plugin_option     *next;
>>
>> Hmm.. this name change reminds me that it might be better if this plugin
>> and option list belong to a pevent..
>
> Yeah, eventually, but for now I want to try to sync what I have in
> trace-cmd with what is here in libtraceevent. At least to save history.
> Then we can modify it to be per pevent. For now, there's no users that
> need it per pevent. But that should definitely be changed before we push
> this out to distros.

Okay.


[SNIP]
>> > +                           free(name);
>> > +                           goto err;
>> > +                   }
>> > +                   list[count++] = name;
>> > +                   list[count] = NULL;
>> > +           }
>> > +   }
>> > +   if (!count)
>> > +           return NULL;
>> > +   return list;
>>
>> Isn't it enough to simply return the list?
>
> Confused. Do you mean "Is it enough to simply return the list?"

I mean that it seems the 'list' is always NULL if the count is zero.


> BTW, Are you at LinuxCon Japan?

Nope, I'll be at LPC instead. :)

Thanks,
Namhyung
