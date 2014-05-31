Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaEaFnA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 01:43:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45840 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbaEaFm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 01:42:59 -0400
Date: Sat, 31 May 2014 15:42:45 +1000
From: NeilBrown <neilb@suse.de>
To: Daniel Dressler <danieru.dressler@gmail.com>
Cc: gregkh@linuxfoundation.org, arve@android.com,
        serban.constantinescu@arm.com, prtvar.b@gmail.com,
        john.stultz@linaro.org, standby24x7@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: android: binder: Fix over-80-char lines
Message-ID: <20140531154245.44e4731b@notabene.brown>
In-Reply-To: <1401510680-13991-1-git-send-email-danieru.dressler@gmail.com>
References: <1401510680-13991-1-git-send-email-danieru.dressler@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/441.h/LtU4vpGdeoAdqAp3S"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/441.h/LtU4vpGdeoAdqAp3S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 30 May 2014 22:31:20 -0600 Daniel Dressler
<danieru.dressler@gmail.com> wrote:

> From: danieru <danieru.dressler@gmail.com>
>=20
> Following Greg Kroah-Hartman's newbie guide to hacking
> the linux kernel this patch addresses only coding style
> issues.
>=20
> Binder still has many too-long lines but I'm worried
> doing too much work in a single patch is unfair to the
> reviewers. So this patch address 20% of the file's
> issues.
>=20
> There is one change to take notice of: it merges two if
> statement's conditionals together. Then it removes a
> redundant else clause.
>=20
> Signed-off-by: Daniel Dressler <danieru.dressler@gmail.com>
> ---
>  drivers/staging/android/binder.c | 89 ++++++++++++++++++++++++----------=
------
>  1 file changed, 54 insertions(+), 35 deletions(-)
>=20
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/b=
inder.c
> index cfe4bc8..6e80861a 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -2211,11 +2211,14 @@ retry:
>  			binder_stats_deleted(BINDER_STAT_TRANSACTION_COMPLETE);
>  		} break;
>  		case BINDER_WORK_NODE: {
> -			struct binder_node *node =3D container_of(w, struct binder_node, work=
);
> +			struct binder_node *node =3D container_of(w,
> +						struct binder_node, work);
>  			uint32_t cmd =3D BR_NOOP;
>  			const char *cmd_name;
> -			int strong =3D node->internal_strong_refs || node->local_strong_refs;
> -			int weak =3D !hlist_empty(&node->refs) || node->local_weak_refs || st=
rong;
> +			int strong =3D node->internal_strong_refs ||
> +						node->local_strong_refs;
> +			int weak =3D !hlist_empty(&node->refs) ||
> +					node->local_weak_refs || strong;
>  			if (weak && !node->has_weak_ref) {
>  				cmd =3D BR_INCREFS;
>  				cmd_name =3D "BR_INCREFS";
> @@ -2311,8 +2314,10 @@ retry:
>  				binder_stats_deleted(BINDER_STAT_DEATH);
>  			} else
>  				list_move(&w->entry, &proc->delivered_death);
> +
> +			/* DEAD_BINDER notifications can cause transactions */
>  			if (cmd =3D=3D BR_DEAD_BINDER)
> -				goto done; /* DEAD_BINDER notifications can cause transactions */
> +				goto done;
>  		} break;
>  		}
> =20
> @@ -2321,7 +2326,8 @@ retry:
> =20
>  		BUG_ON(t->buffer =3D=3D NULL);
>  		if (t->buffer->target_node) {
> -			struct binder_node *target_node =3D t->buffer->target_node;
> +			struct binder_node *target_node =3D
> +							t->buffer->target_node;
>  			tr.target.ptr =3D target_node->ptr;
>  			tr.cookie =3D  target_node->cookie;
>  			t->saved_priority =3D task_nice(current);
> @@ -2344,7 +2350,7 @@ retry:
>  		if (t->from) {
>  			struct task_struct *sender =3D t->from->proc->tsk;
>  			tr.sender_pid =3D task_tgid_nr_ns(sender,
> -							task_active_pid_ns(current));
> +						task_active_pid_ns(current));

If it were my code, I'd say the cure is much worse than the disease.

Stuff inside brackets (any sort) should always be to the right of the openi=
ng
bracket, unless that bracket is at the end of the line.  Then the stuff
inside the brackets should be indented a single tab.

So the only alternative to the original here (which I don't personally think
is worth fixing) is:

>  			tr.sender_pid =3D task_tgid_nr_ns(
>                               sender,	task_active_pid_ns(current));

That way the full list of arguments is still a well defined block that is
easy to see.



>  		} else {
>  			tr.sender_pid =3D 0;
>  		}
> @@ -2575,11 +2581,13 @@ static long binder_ioctl(struct file *filp, unsig=
ned int cmd, unsigned long arg)
>  	unsigned int size =3D _IOC_SIZE(cmd);
>  	void __user *ubuf =3D (void __user *)arg;
> =20
> -	/*pr_info("binder_ioctl: %d:%d %x %lx\n", proc->pid, current->pid, cmd,=
 arg);*/
> +	/*pr_info("binder_ioctl: %d:%d %x %lx\n",
> +					proc->pid, current->pid, cmd, arg);*/
> =20
>  	trace_binder_ioctl(cmd, arg);
> =20
> -	ret =3D wait_event_interruptible(binder_user_error_wait, binder_stop_on=
_user_error < 2);
> +	ret =3D wait_event_interruptible(binder_user_error_wait,
> +						binder_stop_on_user_error < 2);
>  	if (ret)
>  		goto err_unlocked;
> =20
> @@ -2602,10 +2610,10 @@ static long binder_ioctl(struct file *filp, unsig=
ned int cmd, unsigned long arg)
>  			goto err;
>  		}
>  		binder_debug(BINDER_DEBUG_READ_WRITE,
> -			     "%d:%d write %lld at %016llx, read %lld at %016llx\n",
> -			     proc->pid, thread->pid,
> -			     (u64)bwr.write_size, (u64)bwr.write_buffer,
> -			     (u64)bwr.read_size, (u64)bwr.read_buffer);
> +			"%d:%d write %lld at %016llx, read %lld at %016llx\n",
> +			proc->pid, thread->pid,
> +			(u64)bwr.write_size, (u64)bwr.write_buffer,
> +			(u64)bwr.read_size, (u64)bwr.read_buffer);
> =20
>  		if (bwr.write_size > 0) {
>  			ret =3D binder_thread_write(proc, thread,
> @@ -2635,10 +2643,10 @@ static long binder_ioctl(struct file *filp, unsig=
ned int cmd, unsigned long arg)
>  			}
>  		}
>  		binder_debug(BINDER_DEBUG_READ_WRITE,
> -			     "%d:%d wrote %lld of %lld, read return %lld of %lld\n",
> -			     proc->pid, thread->pid,
> -			     (u64)bwr.write_consumed, (u64)bwr.write_size,
> -			     (u64)bwr.read_consumed, (u64)bwr.read_size);
> +			"%d:%d wrote %lld of %lld, read return %lld of %lld\n",
> +			proc->pid, thread->pid,
> +			(u64)bwr.write_consumed, (u64)bwr.write_size,
> +			(u64)bwr.read_consumed, (u64)bwr.read_size);
>  		if (copy_to_user(ubuf, &bwr, sizeof(bwr))) {
>  			ret =3D -EFAULT;
>  			goto err;
> @@ -2646,7 +2654,8 @@ static long binder_ioctl(struct file *filp, unsigne=
d int cmd, unsigned long arg)
>  		break;
>  	}
>  	case BINDER_SET_MAX_THREADS:
> -		if (copy_from_user(&proc->max_threads, ubuf, sizeof(proc->max_threads)=
)) {
> +		if (copy_from_user(&proc->max_threads, ubuf,
> +						sizeof(proc->max_threads))) {
>  			ret =3D -EINVAL;
>  			goto err;
>  		}
> @@ -2657,16 +2666,16 @@ static long binder_ioctl(struct file *filp, unsig=
ned int cmd, unsigned long arg)
>  			ret =3D -EBUSY;
>  			goto err;
>  		}
> -		if (uid_valid(binder_context_mgr_uid)) {
> -			if (!uid_eq(binder_context_mgr_uid, current->cred->euid)) {
> -				pr_err("BINDER_SET_CONTEXT_MGR bad uid %d !=3D %d\n",
> -				       from_kuid(&init_user_ns, current->cred->euid),
> -				       from_kuid(&init_user_ns, binder_context_mgr_uid));
> -				ret =3D -EPERM;
> -				goto err;
> -			}
> -		} else
> -			binder_context_mgr_uid =3D current->cred->euid;
> +		if (uid_valid(binder_context_mgr_uid) &&
> +			!uid_eq(binder_context_mgr_uid, current->cred->euid)) {

This also looks wrong.  visually, the second line above links with the line
below, but conceptually it links with the next line above.
So:
> +		if (uid_valid(binder_context_mgr_uid) &&
> +		    !uid_eq(binder_context_mgr_uid, current->cred->euid)) {

is much more visually consistent.

Apply these rules throughout the patch and, for me at least, the patch will=
 be much better for it.

(I use emacs C-mode with (c-set-style "K&R"), and it always gets the indent=
ing right)

Thanks,
NeilBrown



> +			pr_err("BINDER_SET_CONTEXT_MGR bad uid %d !=3D %d\n",
> +			       from_kuid(&init_user_ns, current->cred->euid),
> +			       from_kuid(&init_user_ns, binder_context_mgr_uid)
> +			       );
> +			ret =3D -EPERM;
> +			goto err;
> +		}
> +		binder_context_mgr_uid =3D current->cred->euid;
>  		binder_context_mgr_node =3D binder_new_node(proc, 0, 0);
>  		if (binder_context_mgr_node =3D=3D NULL) {
>  			ret =3D -ENOMEM;
> @@ -2688,7 +2697,8 @@ static long binder_ioctl(struct file *filp, unsigne=
d int cmd, unsigned long arg)
>  			ret =3D -EINVAL;
>  			goto err;
>  		}
> -		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION, &((struct binder_version=
 *)ubuf)->protocol_version)) {
> +		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION,
> +			&((struct binder_version *)ubuf)->protocol_version)) {
>  			ret =3D -EINVAL;
>  			goto err;
>  		}
> @@ -2702,9 +2712,11 @@ err:
>  	if (thread)
>  		thread->looper &=3D ~BINDER_LOOPER_STATE_NEED_RETURN;
>  	binder_unlock(__func__);
> -	wait_event_interruptible(binder_user_error_wait, binder_stop_on_user_er=
ror < 2);
> +	wait_event_interruptible(binder_user_error_wait,
> +						binder_stop_on_user_error < 2);
>  	if (ret && ret !=3D -ERESTARTSYS)
> -		pr_info("%d:%d ioctl %x %lx returned %d\n", proc->pid, current->pid, c=
md, arg, ret);
> +		pr_info("%d:%d ioctl %x %lx returned %d\n", proc->pid,
> +						current->pid, cmd, arg, ret);
>  err_unlocked:
>  	trace_binder_ioctl_done(ret);
>  	return ret;
> @@ -2784,13 +2796,18 @@ static int binder_mmap(struct file *filp, struct =
vm_area_struct *vma)
> =20
>  #ifdef CONFIG_CPU_CACHE_VIPT
>  	if (cache_is_vipt_aliasing()) {
> -		while (CACHE_COLOUR((vma->vm_start ^ (uint32_t)proc->buffer))) {
> -			pr_info("binder_mmap: %d %lx-%lx maps %p bad alignment\n", proc->pid,=
 vma->vm_start, vma->vm_end, proc->buffer);
> +		uint32_t proc_buffer =3D (uint32_t)proc->buffer;
> +		while (CACHE_COLOUR((vma->vm_start ^ proc_buffer))) {
> +			pr_info(
> +			"binder_mmap: %d %lx-%lx maps %p bad alignment\n",
> +						proc->pid, vma->vm_start,
> +						vma->vm_end, proc->buffer);
>  			vma->vm_start +=3D PAGE_SIZE;
>  		}
>  	}
>  #endif
> -	proc->pages =3D kzalloc(sizeof(proc->pages[0]) * ((vma->vm_end - vma->v=
m_start) / PAGE_SIZE), GFP_KERNEL);
> +	size_t num_pages =3D (vma->vm_end - vma->vm_start) / PAGE_SIZE;
> +	proc->pages =3D kzalloc(sizeof(proc->pages[0]) * num_pages, GFP_KERNEL);
>  	if (proc->pages =3D=3D NULL) {
>  		ret =3D -ENOMEM;
>  		failure_string =3D "alloc page array";
> @@ -2801,7 +2818,8 @@ static int binder_mmap(struct file *filp, struct vm=
_area_struct *vma)
>  	vma->vm_ops =3D &binder_vm_ops;
>  	vma->vm_private_data =3D proc;
> =20
> -	if (binder_update_page_range(proc, 1, proc->buffer, proc->buffer + PAGE=
_SIZE, vma)) {
> +	if (binder_update_page_range(proc, 1, proc->buffer,
> +					proc->buffer + PAGE_SIZE, vma)) {
>  		ret =3D -ENOMEM;
>  		failure_string =3D "alloc small buf";
>  		goto err_alloc_small_buf_failed;
> @@ -2887,7 +2905,8 @@ static void binder_deferred_flush(struct binder_pro=
c *proc)
>  	struct rb_node *n;
>  	int wake_count =3D 0;
>  	for (n =3D rb_first(&proc->threads); n !=3D NULL; n =3D rb_next(n)) {
> -		struct binder_thread *thread =3D rb_entry(n, struct binder_thread, rb_=
node);
> +		struct binder_thread *thread =3D rb_entry(n, struct binder_thread,
> +								rb_node);
>  		thread->looper |=3D BINDER_LOOPER_STATE_NEED_RETURN;
>  		if (thread->looper & BINDER_LOOPER_STATE_WAITING) {
>  			wake_up_interruptible(&thread->wait);


--Sig_/441.h/LtU4vpGdeoAdqAp3S
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4lr1Tnsnt1WYoG5AQLrsRAAoTNnVRAaRI5d1/xmcqWfhOCnP6mTU+Tc
If7qvhy4N1fR8zg0ZLzkTlp3buRYOJsY4ZrjdYDMfh2VVX69FccRu55SnghCEc4f
KXXcM1+coIbGAmpVkLBehFzMUuZ5UWDHL+cbXiH+y4R9IIA+thO7ME6lKpg4Li+V
RF0opzYsV9aD9jg39Qx44lDOUi6tMouht7SbPtTYM7AHVOlfaS5wY7SSMky5LDke
QegYc2UnJfyBb12doti5xvz7C7/3rBP5Pz/DKHDO+F20wodFO6zsA+gJ6dtFEeSZ
q5ZoEF0fUVv+q3yV9ZTP41Ce72DVrXDSlAlRdDavNqnqd8Ofwo70nnOdvLnj34b3
HnPMJ7rfcmI/bJMXszh5KBGG00URsSVjOOddXVuw+L8ODsx5ZZUrZ93OwrO4V8tL
36W+DFMaQGmA0YIBrgeMejmDHeer78tC4FZMu24vfgspFIaeUUyCLTeZh1pUage3
d3uW/vwddmZ9oDLOdzvFkS6H1crNDUCcVDtAdwYuOztMzUfcnGqiV+kS3XvTkx5I
b+HbsqV/CSGJF9IF9BPwGXAF1eCTnOVlDuf4BYqSzwZ7+YyUsayVUOTskuAfLGIV
Dk4i7SnBHRC79mSyR5kYDRr2sYOajgu5i09WzPw49ox8OOgDB2Et57Sxt7GeJ1wf
+V2OuiMeG5I=
=Pmrj
-----END PGP SIGNATURE-----

--Sig_/441.h/LtU4vpGdeoAdqAp3S--
