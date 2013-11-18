Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3KRW6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 17:58:46 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:53638 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3KRW6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 17:58:45 -0500
Date: Mon, 18 Nov 2013 14:58:41 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: anish singh <anish198519851985@gmail.com>
Cc: =?utf-8?B?6Z+p56OK?= <bonben1989@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: list_head and lock?
Message-ID: <20131118225841.GI4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAK2Ky6zUfngvgKAaqNzTN9KPY2zgir3Yevj-r_=wWq=1RN3yAw@mail.gmail.com>
 <CAK7N6vpL+zXrb+2uoT3=kggAin34k+FkB-bt1_Sgw17uC5MkLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK7N6vpL+zXrb+2uoT3=kggAin34k+FkB-bt1_Sgw17uC5MkLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111822-8236-0000-0000-000003EECDA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 05:48:14PM -0800, anish singh wrote:
> On Sun, Nov 17, 2013 at 5:19 PM, 韩磊 <bonben1989@gmail.com> wrote:
> > when we delete,add,search,amend the list_head,should we use spinlock
> > or rcu in case of conflicit to list_head???
> There is no implicit locking when we use 'list' api's.You should explicitly
> do that AFAIK.

See Documentation/RCU/listRCU.txt for a summary of how to use RCU-protected
linked lists.  But yes, readers need to explicitly do rcu_read_lock()
and rcu_read_unlock(), and updaters must coordinate with each others
somehow, for example, explicitly using spinlocks.

The list_head macros are about list manipulation and not so much about
synchronization.

							Thanx, Paul

