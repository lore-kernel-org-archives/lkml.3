Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaC3D4m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 23:56:42 -0400
Received: from one.firstfloor.org ([193.170.194.197]:60088 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbaC3D4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 23:56:40 -0400
Date: Sun, 30 Mar 2014 05:56:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 12/29] ktap: add generic object handling
 code(kernel/trace/ktap/kp_obj.[c|h])
Message-ID: <20140330035639.GC22728@two.firstfloor.org>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
 <1396017924-7754-13-git-send-email-jovi.zhangwei@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396017924-7754-13-git-send-email-jovi.zhangwei@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> + * You should have received a copy of the GNU General Public License along with
> + * this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.

We're not supposed to use the address anymore.

> +/* memory allocation flag */
> +#define KTAP_ALLOC_FLAGS ((GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN) \
> +			 & ~__GFP_WAIT)
> +
> +void *kp_malloc(ktap_state_t *ks, int size)
> +{
> +	void *addr;
> +
> +	addr = kmalloc(size, KTAP_ALLOC_FLAGS);
> +	if (unlikely(!addr)) {
> +		kp_error(ks, "kmalloc failed\n");
> +	}
> +	return addr;

Please remove this pointless wrapper. Similar for the functions below.
Just use kmalloc etc. directly.

> +	case KTAP_TNUM:
> +		kp_printf(ks, "NUM %ld", nvalue(v));

Similar here. That's all printk


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
