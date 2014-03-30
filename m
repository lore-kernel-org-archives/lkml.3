Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbaC3IOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 04:14:47 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:57233 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaC3IOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 04:14:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140330035639.GC22728@two.firstfloor.org>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
	<1396017924-7754-13-git-send-email-jovi.zhangwei@gmail.com>
	<20140330035639.GC22728@two.firstfloor.org>
Date: Sun, 30 Mar 2014 16:14:42 +0800
Message-ID: <CAGdX0WHegT+r6ZMLSdRFDA60Zg89SUTYNxGuhAG=PBJ4=Rr4Tg@mail.gmail.com>
Subject: Re: [PATCH v2 12/29] ktap: add generic object handling code(kernel/trace/ktap/kp_obj.[c|h])
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 11:56 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> + * You should have received a copy of the GNU General Public License along with
>> + * this program; if not, write to the Free Software Foundation, Inc.,
>> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
>
> We're not supposed to use the address anymore.
>
I will update it.

>> +/* memory allocation flag */
>> +#define KTAP_ALLOC_FLAGS ((GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN) \
>> +                      & ~__GFP_WAIT)
>> +
>> +void *kp_malloc(ktap_state_t *ks, int size)
>> +{
>> +     void *addr;
>> +
>> +     addr = kmalloc(size, KTAP_ALLOC_FLAGS);
>> +     if (unlikely(!addr)) {
>> +             kp_error(ks, "kmalloc failed\n");
>> +     }
>> +     return addr;
>
> Please remove this pointless wrapper. Similar for the functions below.
> Just use kmalloc etc. directly.
>
Reasonable, save a extra function call.

>> +     case KTAP_TNUM:
>> +             kp_printf(ks, "NUM %ld", nvalue(v));
>
> Similar here. That's all printk
>
Hmm, kp_printf is not printk, there is not printk in ktap,
all content is dump to ring buffer, we cannot use printk in prove context.

And we allow multiple ktap instances running at same time,
so different ktap instance have different ring buffer, that's why we have to
pass the context variable "ks" into kp_printf.

Thanks.

Jovi
